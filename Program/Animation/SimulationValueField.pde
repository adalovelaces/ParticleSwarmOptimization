class ValueField {

  private int num;                       // Number of the selected function
  private float maxValue;
  private float minValue;
  private VectorCoord posOptimum;
  private float sizeMinimum;
  private color colorMinimum;
  private MovingPeaks movingPeaksFunction;
  private int movingPeaksScenarioNum;
  private boolean staticOptimisation;
  private boolean dynamicOptimisation;

  /*------------------------------------------------------------*/
  /*                           CONSTRUCTOR                      */
  /*------------------------------------------------------------*/

  ValueField( int num ) {

      this.posOptimum = new VectorCoord( cfg.PSO_X, cfg.PSO_Y );
      this.sizeMinimum = cfg.PSO_MINIMUM_SIZE;
      this.colorMinimum = cfg.COLOR_MINIMUM;

      this.num = num;

      if( cfg.PSO_MINIMIZING ){

          this.maxValue = -cfg.PSO_INIT;
          this.minValue = cfg.PSO_INIT;

      }

      if( cfg.PSO_MAXIMIZING ){

          this.maxValue = cfg.PSO_INIT;
          this.minValue = -cfg.PSO_INIT;

      }

  }

  void resetOptimum(){

      // Use sphere, rosenbrock, ackley
      //this.resetOptimumStaticOptimization();

  }

  void resetOptimumStaticOptimization(){

      float xMin = cfg.SIMULATION_MIN_X;
      float xMax = cfg.SIMULATION_MAX_X;
      float yMin = cfg.SIMULATION_MIN_Y;
      float yMax = cfg.SIMULATION_MAX_Y;

      float newX = ( float ) ( Math.random() * ( ( xMax - xMin ) ) ) + xMin;
      float newY = ( float ) ( Math.random() * ( ( yMax - yMin ) ) ) + yMin;

      this.posOptimum.x = newX;
      this.posOptimum.y = newY;

  }

  /*------------------------------------------------------------*/
  /*                          DISPLAY                           */
  /*------------------------------------------------------------*/

  void drawMinimum(){

      // Transfer position from coordinate values to screen values
      VectorScreen screenPos = this.posOptimum.transToScreen();

      float x = screenPos.x;
      float y = screenPos.y;

      fill( this.colorMinimum );
      noStroke();
      pushMatrix();
      ellipse( x, y, this.sizeMinimum, this.sizeMinimum );
      popMatrix();

  }

  /*------------------------------------------------------------*/
  /*                           GETTER                           */
  /*------------------------------------------------------------*/

  // Input: Coordinates
  float getValue( VectorCoord coordPos ){

      float x = coordPos.x;
      float y = coordPos.y;

      // Calculate the function value accordingly to the function
      switch( num ){

          case 1:
            return fnSphere( x, y );

          case 2:
            return fnRosenbrock( x, y );

          case 3:
            return fnAckley( x, y );

          default:
            return 0;

      }
  }

  /*------------------------------------------------------------*/
  /*                           FUNCTIONS                        */
  /*------------------------------------------------------------*/

  float fnSphere( float x, float y ){

      x -= this.posOptimum.x;
      y -= this.posOptimum.y;

      return pow( x, 2 ) + pow( y, 2 );

  }

  float fnRosenbrock( float x , float y ){

      // Would be 100 * but values were very large
      //double value = pow( y - pow( x, 2 ), 2 ) + pow( x - 1, 2 );
      //return (float) value;
      //100*((x - uT + 1).^2 - (y - vT + 1)).^2 + (x - uT).^2;
      x -= this.posOptimum.x;
      y -= this.posOptimum.y;

      float result1 = pow( x + 1, 2 );
      float result2 = y + 1;
      float result3 = pow( x, 2 );
      float value = 100 * pow( result1 - result2, 2 ) + result3;

      return value;

  }

  float fnAckley( float x, float y ){

      x -= this.posOptimum.x;
      y -= this.posOptimum.y;
      /*
      float a = x;
      float b = y;

      float c1 = 20;
      float c2 = 0.2;
      float c3 = 2 * (float) Math.PI;

      float r1 = -c1 * exp( -c2 *  sqrt( ( pow( a, 2 ) + pow( b, 2 ) )  / 2 ) );
      float r2 = -exp( ( cos( c3 * a ) + cos( c3 * b ) ) / 2 );
      float r3 = c1;
      float r4 = exp( 1 );

      float z = r1 + r2 + r3 + r4;
      //return z ;
      */


      double sum1 = 0;
	  double sum2 = 0;

        double a = 20;
        double b = 0.2;
        double c = 2*Math.PI;
        double d = 2;

		sum1 += Math.pow(x, 2);
        sum1 += Math.pow(y, 2);

        sum2 += Math.cos(c*x);
		sum2 += Math.cos(c*y);

        double r1 = -b * Math.sqrt( sum1 / d );
        double r2 = Math.sqrt( sum2 / d );
  	    double value = -a*Math.exp( r1 ) - Math.exp( r2 ) + a + Math.exp( 1 );

        //MATLAB Z = -c1 * exp(-c2*sqrt(((x-uT).^2+(y-vT).^2)/2)) - exp((cos(c3*(x-uT))+cos(c3*(y-vT)))/2) + c1 + exp(1);
         value = -a * Math.exp( -b * Math.sqrt( ((Math.pow( x, 2) + Math.pow( y, 2 ))) / 2 ) ) - Math.exp( (Math.cos( c * x ) + Math.cos( c * y )) / 2 ) + a + Math.exp( 1 );
        //a + Math.exp(1) + d - a*Math.exp(-b*Math.sqrt(sum1/2)) - Math.exp(sum2/2);

        //double p1 = -20*Math.exp(-0.2*Math.sqrt(0.5*((x*x)+(y*y))));
                //double p2 = Math.exp(0.5*(Math.cos(2*Math.PI*x)+Math.cos(2*Math.PI*y)));
                //value = p1 - p2 + Math.E + 20;
        return (float) value;

    /*
      double sum1 = x+y;
      double sum2 = x+y;
      double value = -20.0*Math.exp(-0.2*Math.sqrt(sum1 / ((double )2))) + 20 - Math.exp(sum2 /((double )2)) + Math.exp(1.0);
      return (float) value;
      */
  }

}
