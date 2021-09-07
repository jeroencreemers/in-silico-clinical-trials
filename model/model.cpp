#include <iostream>
#include <cstdlib>
#include <getopt.h>
#include <stdlib.h> // contains exit()
#include <boost/array.hpp>

#include <boost/numeric/odeint.hpp>
#include <boost/math/interpolators/cubic_b_spline.hpp>

#include <boost/random.hpp>
#include <boost/random/normal_distribution.hpp>

using namespace std;
using namespace boost::numeric::odeint;


/* Set parameters */
const double alpha = 0.0025, //priming rate
             delta = 0.019;    // death rate immune cells

const double hI = 571, // Michaelis constant
             hT = 571; // Michaelis constant

      double xi = 0.001, // default killing rate immune cells
             R = 5; // growth rate tumor

         int STOCHASTIC_KILLING = 0, // default flag stochastic killing (= off)
             STOCHASTIC_GROWTH = 0; // default flag stochastic growth (= off)

      double DIAGNOSIS_THRESHOLD = 65*1e8, // default tumor size for diagnosis threshold
             DIAGNOSED_AT = numeric_limits<double>::infinity(),
             RAISE_KILLING = 1.0, // multiplication factor of killing rate by imm. therapy
             LOWER_GROWTH = 1.0, // multiplication factor of growth rate by chemotherapy
             TREATMENT_DURATION = numeric_limits<double>::infinity(),
             CHEMO_DURATION = numeric_limits<double>::infinity(),
             IMMUNO_START = 0,
             CHEMO_START = 0;

      double DRIFT_XI = 0, // drift terms
             DRIFT_R = 0;

      double t_max = 1825.0; // simulation duration

      double seed = time(0)+getpid();
      double GROWTH_RATE_DECAY_RATE = 0; // decay rate of tumor growth

typedef boost::array< double , 4 > state_type;


/* Make interpolation function */
vector<double> f(500);
vector<double> g(500);
boost::math::cubic_b_spline<double> spline_f, spline_g;

// Function to generate time-dep. killing rate
double xi_t( double t ){
    return ( xi * ( 1 + DRIFT_XI * ( t / t_max ) ) * spline_f(t) );
}

// Function for time-depedent growth rate
double R_t( double t ){
	double r;
	double t_eff = t/t_max;

    if(GROWTH_RATE_DECAY_RATE != 0){
		t_eff = (exp( -GROWTH_RATE_DECAY_RATE * t_eff)-1)/-GROWTH_RATE_DECAY_RATE;
	}
	double a0 = R*DRIFT_R;
	r = R + a0 * t_eff;
	r = r * spline_g(t_eff);
    r = r / ( 1 + exp( -4 * r )); // logistic transformation
	return r;
}

/* TUMOR MODEL */
void tumormodel( const state_type &x , state_type &dxdt , double t )
{
    const double T = x[0], N = x[3], S = x[2], I = x[1];

    const double t_cell_activation = alpha * ( T / (1e7 + T) ) * N;

    double killing, growth;

    // Set time of diagnosis
    if( T > DIAGNOSIS_THRESHOLD ){
        if( t < DIAGNOSED_AT )
            DIAGNOSED_AT = t;
    }


    if( STOCHASTIC_KILLING )
        killing = xi_t(t) * I * T / (1 + I/hI + T / hT); // time-dependent killing
    else
         killing = xi * I * T / (1 + I/hI + T / hT);      // time-independent killing


    if( STOCHASTIC_GROWTH )
        growth = R_t(t); // time-dependent growth
    else
        growth = R;
    
    // Start immunotherapy if: one day after diagnosis, a treatment effect is set (RAISE_KILLING),
    // and time is within treatment duration
    if( (t > (DIAGNOSED_AT+1)) && (RAISE_KILLING != 1.0) && (t >= (DIAGNOSED_AT + IMMUNO_START) ) && (t <= (DIAGNOSED_AT + IMMUNO_START + TREATMENT_DURATION)) )
        killing *= RAISE_KILLING;
    
    // Start chemotherapy if: one day after diagnosis, a treatment effect is set (LOWER_GROWTH),
    // and time is within treatment duration
    if( (t > (DIAGNOSED_AT+1)) && (LOWER_GROWTH != 1.0) && (t >= (DIAGNOSED_AT + CHEMO_START) ) && (t <= (DIAGNOSED_AT + CHEMO_START + CHEMO_DURATION)) )
        growth *= LOWER_GROWTH;


    if ( T < 1 )
        dxdt[0] = -T;                                  // tumor cells
    else
        dxdt[0] = growth * pow( T , 4./5. ) - killing; // tumor cells

    dxdt[1] = S - delta*I;                             // TILs
    dxdt[2] = t_cell_activation;                       // specific T cells
    dxdt[3] = - t_cell_activation;                     // naive T cells
}

/* Print output */
void write_solution( const state_type &x , const double t)
{
    // Stop printing if tumor cells > 10^12 (= patient death)
    if (x[0] > 1e12){
        exit ( 0 );
    }
    if( STOCHASTIC_GROWTH ){
         cout << t << "\t"<< R_t(t);
    } else {
         cout << t << "\t" << R;
    }
    if( STOCHASTIC_KILLING )
        cout << "\t" << xi_t(t);
    else
        cout << "\t" << xi;
    cout << "\t" << DRIFT_R;
    cout << "\t" << GROWTH_RATE_DECAY_RATE;
    for( int i = 0 ; i < 4 ; i ++ )
        cout << "\t" << x[i];
  cout << endl;
}


#define XI_OPT 1000
#define R_OPT 1001
#define STOCHASTIC_KILLING_OPT 1002
#define RAISE_KILLING_OPT 1003
#define TREATMENT_DURATION_OPT 1004
#define STOCHASTIC_GROWTH_OPT 1005
#define DRIFT_XI_OPT 1006
#define DRIFT_R_OPT 1007
#define SEED_OPT 1008
#define DIAGNOSIS_THRESHOLD_OPT 1009
#define GROWTH_DECAY_OPT 1010
#define LOWER_GROWTH_OPT 1011
#define CHEMO_DURATION_OPT 1012
#define CHEMO_START_OPT 1013
#define IMMUNO_START_OPT 1014

static struct option command_line_options[] =
{
    {"xi", required_argument, NULL, XI_OPT},
    {"R", required_argument, NULL, R_OPT},
    {"stochastic-killing", required_argument, NULL, STOCHASTIC_KILLING_OPT},
    {"raise-killing", required_argument, NULL, RAISE_KILLING_OPT},
    {"treatment-duration", required_argument, NULL, TREATMENT_DURATION_OPT},
    {"stochastic-growth", required_argument, NULL, STOCHASTIC_GROWTH_OPT},
    {"drift-xi", required_argument, NULL, DRIFT_XI_OPT},
    {"drift-R", required_argument, NULL, DRIFT_R_OPT},
    {"seed", required_argument, NULL, SEED_OPT},
    {"diagnosis-threshold", required_argument, NULL, DIAGNOSIS_THRESHOLD_OPT},
    {"growth-decay", required_argument, NULL, GROWTH_DECAY_OPT},
    {"lower-growth", required_argument, NULL, LOWER_GROWTH_OPT},
    {"chemo-duration", required_argument, NULL, CHEMO_DURATION_OPT},
    {"chemo-start", required_argument, NULL, CHEMO_START_OPT},
    {"immuno-start", required_argument, NULL, IMMUNO_START_OPT},
};


int main(int argc, char **argv)
{
    // Parse command line options
    int c;
    double KILLING_SD = 0;
    double GROWTH_SD = 0;
    while ((c = getopt_long(argc, argv, "", command_line_options, NULL)) != -1){
        switch(c){
            case XI_OPT:
                xi = atof(optarg);
                break;
            case R_OPT:
                R = atof(optarg);
                break;
            case STOCHASTIC_KILLING_OPT:
                STOCHASTIC_KILLING = 1;
                KILLING_SD = atof(optarg);
                break;
            case STOCHASTIC_GROWTH_OPT:
                STOCHASTIC_GROWTH = 1;
                GROWTH_SD = atof(optarg);
                break;
            case RAISE_KILLING_OPT:
                RAISE_KILLING = atof(optarg);
                break;
            case TREATMENT_DURATION_OPT:
                TREATMENT_DURATION = atof(optarg);
                break;
            case DRIFT_XI_OPT:
                DRIFT_XI = atof(optarg);
                break;
            case DRIFT_R_OPT:
                DRIFT_R = atof(optarg);
                break;
            case SEED_OPT:
                if(atof(optarg) != 0){
                    seed = atof(optarg);
                }
                break;
            case DIAGNOSIS_THRESHOLD_OPT:
                DIAGNOSIS_THRESHOLD = atof(optarg);
                break;
            case GROWTH_DECAY_OPT:
                GROWTH_RATE_DECAY_RATE = atof(optarg);
                break;
            case LOWER_GROWTH_OPT:
                LOWER_GROWTH = atof(optarg);
                break;
            case CHEMO_DURATION_OPT:
                CHEMO_DURATION = atof(optarg);
                break;
            case CHEMO_START_OPT:
                CHEMO_START = atof(optarg);
                break;
            case IMMUNO_START_OPT:
                IMMUNO_START = atof(optarg);
                break;
        }
    }

    /*Function to generate a random number*/
    boost::mt19937 rng(seed);
    boost::normal_distribution<> nd(0.0, 1.0);
    boost::variate_generator<boost::mt19937&,
                           boost::normal_distribution<> > rnorm(rng, nd);
    
    // Fill vector f with i, returns a vector (size=500) with scaled random numbers
    for (auto& i: f)
        i = 1 + rnorm()*KILLING_SD;
    f[0] = 1;
    
    // Create object cubic_b_spline (constructor);
    spline_f = boost::math::cubic_b_spline<double>(f.begin(), f.end(), 0.0, 30.5);

    for (auto& i: g)
        i = 1 + rnorm()*GROWTH_SD;
    g[0] = 1;
    
    spline_g = boost::math::cubic_b_spline<double>(g.begin(), g.end(), 0.0, 30.5);

    state_type x = {{ 1.0, 0., 0., 1e6 }};
    //integrate(tumormodel, x, 0.0, 2500.0, 1.0, write_solution );
    controlled_runge_kutta<runge_kutta_dopri5 < state_type >> stepper;

    integrate_const( stepper, tumormodel, x, 0.0, t_max*2, 1.0, write_solution );
}
