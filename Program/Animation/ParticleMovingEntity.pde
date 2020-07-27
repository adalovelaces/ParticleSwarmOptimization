//===================================================//
//                 MOVING ENTITY                     //
//===================================================//

class MovingEntity implements Comparable{

  protected float[][] initX;
  protected float[][] initY;

  protected float radius;
  protected color c;
  protected int num;
  protected float battery;
  protected float usedEnergy;

  protected Laser laser;

  protected float maxSpeed;
  protected VectorCoord position;
  protected VectorCoord lastPosition;
  protected VectorCoord velocity;
  protected VectorCoord discVelocity;

  protected ArrayList<VectorCoord> positionList;
  protected int positionListSize;

  //===================================================//
  //                   CONSTRUCTOR                     //
  //===================================================//

  MovingEntity( color _c, int _num ) {

      this.c = _c;
      this.num = _num;
      this.laser = null;

      this.init();

  }

  //===================================================//
  //                    INITIALISATION                 //
  //===================================================//

  void init(){

      this.importInitilisationPositions();

      VectorCoord startPos = this.getStartPosition( cfg.PARTICLE_START_POSITION );

      this.position = new VectorCoord( startPos.x, startPos.y );
      this.lastPosition = new VectorCoord( startPos.x, startPos.y );
      this.velocity = new VectorCoord( 0, 0 );
      this.discVelocity = new VectorCoord( 0, 0 );

      this.positionListSize = cfg.PARTICLE_DISPLAY_TRACKLISTSIZE;
      this.initPositionList();

      this.maxSpeed = cfg.PARTICLE_VELOCITY_MAX;
      this.radius = cfg.PARTICLE_SIZE_COORDINATE;
      this.battery = cfg.PARTICLE_BATTERY;
      this.usedEnergy = 0;

  }

  void initPositionList(){

      this.positionList = new ArrayList<VectorCoord>();
      for( int i = 0; i < this.positionListSize; i++ ){

          this.positionList.add( this.position.copy() );

      }

  }

  VectorCoord getStartPosition( int num ){

      //if( cfg.ANALYSIS ){
          return this.getStartPositionSimulation();
     // }
    //  else{
    //      return this.getStartPositionAnimation( num );
    //  }

  }

  float[][] importInit( String path ){

      float[][] values = new float[ 31 ][ 20 ];

      File file = new File( path );

      boolean read = false;
      Scanner scanner = null;

      if( file.exists() ){

          try {

              scanner = new Scanner( file );

              scanner.useDelimiter( "\n" );

              String row = "";
              int count = 0;
              float[] rowValues = new float[ 20 ];
              float value = 0;

              while( scanner.hasNext() ){

                  row = scanner.next();

                  // Read a row of values (array) and store it in multidimensional result matrix

                  String [] cells = row.split(",");

                  rowValues = new float[ 20 ];

                  for( int i = 0; i < cells.length-1; i++ ){

                      value = Float.parseFloat( cells[ i ] );
                      rowValues[ i ] = value;

                  }

                  values[ count ] = rowValues;
                  count++;

              }

              scanner.close();

        }

        catch (FileNotFoundException ex) {

           ex.printStackTrace();

        }

        finally {
            if(scanner!=null)

                scanner.close();
                scanner = null;
        }

      }

      return values;

  }

  void importInitilisationPositions(){

      String filePath = System.getProperty("user.dir");
      File file = new File( filePath );
      String absoluteFilePath = file.getAbsolutePath();
      String path = Paths.get( absoluteFilePath ).getParent().toString();

      String dataPath = path;

      dataPath = path.replace( "\\", "/" );

      dataPath = cfg.PATH_FOLDER;
      dataPath += "/Data/";

      String data_x = dataPath + "init_x.txt";
      String data_y = dataPath + "init_y.txt";

      this.initX = this.importInit( data_x );
      this.initY = this.importInit( data_y );

  }

  VectorCoord getStartPositionSimulation(){

      float x = this.initX[ cfg.SIM_NUM ][ this.num ];
      float y = this.initY[ cfg.SIM_NUM ][ this.num ];

      return new VectorCoord( x, y );

  }

  VectorCoord getStartPositionAnimation( int num ){

      String type = cfg.PARTICLE_START_POSITION_TYPES[ num ];

      float maxX = 0;
      float minX = 0;
      float maxY = 0;
      float minY = 0;

      float absX = Math.abs( cfg.SIMULATION_MAX_X ) + Math.abs( cfg.SIMULATION_MIN_X );
      float absY = Math.abs( cfg.SIMULATION_MAX_Y ) + Math.abs( cfg.SIMULATION_MIN_Y );

      float simMinX = cfg.SIMULATION_MIN_X;
      float simMinY = cfg.SIMULATION_MIN_Y;

      if( type == "RightTopCorner" ){

          maxX = absX * 0.95 + simMinX;
          minX = absX * 0.75 + simMinX;
          maxY = absY * 0.95 + simMinY;
          minY = absY * 0.75 + simMinY;

      }

      if( type == "LeftBottomCorner" ){

          maxX = absX * 0.25 + simMinX;
          minX = absX * 0.05 + simMinX;
          maxY = absY * 0.25 + simMinY;
          minY = absY * 0.05 + simMinY;

      }

      if( type == "RightBottomCorner" ){

          maxX = absX * 0.95 + simMinX;
          minX = absX * 0.8 + simMinX;
          maxY = absY * 0.25 + simMinY;
          minY = absY * 0.05 + simMinY;

      }

      if( type == "Circle" ){



      }

      if( type == "Row" ){

          maxX = absX * 0.9 + simMinX;
          minX = absX * 0.1 + simMinX;
          maxY = absY * 0.1 + simMinY;
          minY = absY * 0.1 + simMinY;

      }

      if( type == "Random" ){

          maxX = cfg.SIMULATION_MAX_X - cfg.PARTICLE_SIZE_COORDINATE;
          minX = cfg.SIMULATION_MIN_X + cfg.PARTICLE_SIZE_COORDINATE;
          maxY = cfg.SIMULATION_MAX_Y - cfg.PARTICLE_SIZE_COORDINATE;
          minY = cfg.SIMULATION_MIN_Y + cfg.PARTICLE_SIZE_COORDINATE;

      }

      float x = ( float ) ( Math.random() * ( ( maxX - minX ) ) ) + minX;
      float y = ( float ) ( Math.random() * ( ( maxY - minY ) ) ) + minY;

      return new VectorCoord( x, y ).copy();

  }

  //===================================================//
  //                      GETTER                       //
  //===================================================//

  int getNum(){

      return this.num;

  }

  //===================================================//
  //                      ENERGY                       //
  //===================================================//

  VectorCoord calcEnergyUsage( VectorCoord move, VectorCoord flow ){

      float calculatedEnergy = 0;

      if( cfg.SIM_USE_ENERGY ){

          calculatedEnergy = calcEnergy( move.copy(), flow.copy() );

      }

      if( calculatedEnergy == 0 || this.battery - calculatedEnergy <= 0 ){

          this.usedEnergy = 0;
          return new VectorCoord( 0, 0 );
      }

      else{

          this.usedEnergy = calculatedEnergy;
          return move.copy();

      }

  }

  void useEnergy( VectorCoord flow ){

      this.battery -= this.usedEnergy;
      return;
      /*
      VectorCoord lastPos = this.lastPosition.copy();
      VectorCoord newPos = this.position.copy();
      newPos.sub(lastPos);

      VectorCoord move = newPos.copy();

      if( move.mag() < 0.00001 ){
          move = new VectorCoord(0,0);
      }

      move.limit( cfg.PARTICLE_VELOCITY_MAX );

      float calculatedEnergy = 0;

      if( cfg.SIM_USE_ENERGY ){

          calculatedEnergy = calcEnergy( move.copy(), flow.copy() );

      }
      */


  }

  float calcEnergy( VectorCoord move, VectorCoord flow ){

      if( move.mag() == 0 ){
          return 0.0;
      }

      float x = this.position.x;
      float y = this.position.y;
      if( x <= cfg.SIMULATION_MIN_X + 0.5 || x >= cfg.SIMULATION_MAX_X - 0.5 || y <= cfg.SIMULATION_MIN_Y + 0.5 || y >= cfg.SIMULATION_MAX_Y - 0.5 ){
          return 0.0;
      }

      float angle = (float) Math.abs( move.getAngle( flow.copy() ) );
      float moveMag = move.mag();
      float flowMag = flow.mag();

      //float maxAngle = 244.86832980505137;
      //energyAngle = ( energyAngle / maxAngle );

      float angleRatio = angle / 360;
      float energyAngle = (float) (Math.pow( 10, angleRatio ) *( angle - 150 ) + 150);
      float energyWind = flowMag / cfg.PARTICLE_FLOW_MAX;
      float energyMove = moveMag / cfg.PARTICLE_VELOCITY_MAX;

      float energy = energyMove * ( 1 + energyAngle * ( 1 + energyWind ) );

      //energy = energyAngle;
      return energy;

  }

  //===================================================//
  //                      MOVEMENT                     //
  //===================================================//

  void move() {

      this.updatePosition( this.discVelocity.copy() );

      this.updatePositionList();

      this.laser.updateParticlePos( this.position.copy() );
      this.laser.move();

  }

  void updatePosition( VectorCoord vel ) {

      this.lastPosition = this.position.copy();

      float nextX = this.position.x + vel.x;
      float nextY = this.position.y + vel.y;

      float newX = nextX;
      float newY = nextY;

      float minX = cfg.SIMULATION_MIN_X + cfg.PARTICLE_SIZE_COORDINATE / 2;
      float maxX = cfg.SIMULATION_MAX_X - cfg.PARTICLE_SIZE_COORDINATE / 2;
      float minY = cfg.SIMULATION_MIN_Y + cfg.PARTICLE_SIZE_COORDINATE / 2;
      float maxY = cfg.SIMULATION_MAX_Y - cfg.PARTICLE_SIZE_COORDINATE / 2;

      if( nextX < minX ){
          //newX = minX + (minX - nextX);
          newX = maxX + ( nextX - minX );
      }

      if( nextX > maxX ){
          //newX = maxX - ( nextX - maxX);
          newX = minX + ( nextX - maxX );
      }

      if( nextY < minY ){
          //newY = minY + (minY - nextY);
          newY = maxY + ( nextY - minY );
      }

      if( nextY > maxY ){
          //newY = maxY - ( nextY - maxY );
          newY = minY + ( nextY - maxY );
      }

      this.position.x = newX;
      this.position.y = newY;

  }


  void bounceOff( Particle other ){

      VectorCoord pos1 = this.position.copy();
      VectorCoord pos2 = other.position.copy();

      VectorCoord vel1 = this.velocity.copy();
      VectorCoord vel2 = other.velocity.copy();

      VectorCoord v1 = new VectorCoord( pos1.x, pos1.y );
      VectorCoord v2 = new VectorCoord( pos2.x, pos2.y );
      VectorCoord diffPos = new VectorCoord().sub( v2, v1 );
      VectorCoord diffVel = new VectorCoord().sub( vel2, vel1 );

      float diff = diffPos.x * diffVel.x + diffPos.y * diffVel.y;

      float dist = this.radius * 2;

      float j = 2 * 1 * diff / ( 1 + 1 ) * dist;
      float jx = j * diffPos.x / dist;
      float jy = j * diffPos.y / dist;
      VectorCoord force = new VectorCoord( jx, jy );

      this.discVelocity.add( force.copy() );
      other.discVelocity.sub( force.copy() );

      this.velocity.add( force.copy() );
      other.velocity.sub( force.copy() );

      this.position.add( force.copy() );
      other.position.sub( force.copy() );

  }

  //===================================================//
  //                      HELPER                       //
  //===================================================//

  void updatePositionList(){

      int intervall = 0;
      if( cfg.SIM_SHOW_CONTINUOUS ) intervall = (int) ( cfg.SIMULATION_SUBITERATIONS / 10 );
      if( !cfg.SIM_SHOW_CONTINUOUS ) intervall = (int) ( cfg.SIMULATION_SUBITERATIONS / 10 );

      if( intervall < 10 ){
          intervall = 1;
      }

      if( countFrames % intervall == 0 ){

          this.positionList.add( this.position.copy() );
          this.positionList.remove( 0 );

      }

  }

  boolean isMouseOver(){

      VectorScreen screenPos = this.position.transToScreen();
      float screenRadius = this.radius * cfg.SIMULATION_RESOLUTION;

      boolean inXRange = mouseX > screenPos.x - screenRadius / 2 && mouseX < screenPos.x + screenRadius / 2;
      boolean inYRange = mouseY > screenPos.y - screenRadius / 2 && mouseY < screenPos.y + screenRadius / 2;

      if( inXRange && inYRange ){

          return true;

      }

      return false;

  }

  @Override
  public int compareTo( Object compareMovingEntity ) {

      float compareNum = ( (MovingEntity) compareMovingEntity).getNum();

      if( compareNum > this.num ) return -1;
      if( compareNum < this.num ) return 1;
      return 0;

  }

  public String toString(){

      return Integer.toString( this.num );

  }



  //===================================================//
  //                      DRAW                         //
  //===================================================//

  void drawPositionList(){

      for( int i = 0; i < this.positionListSize; i++ ){

          VectorScreen screenPos = this.positionList.get( i ).copy().transToScreen();

          fill( cfg.COLOR_PARTICLE_POSITIONLIST, i * 10 );
          noStroke();
          pushMatrix();
          ellipseMode(CENTER);
          ellipse( screenPos.x, screenPos.y, cfg.PARTICLE_DISPLAY_TRACKPOINTSIZE, cfg.PARTICLE_DISPLAY_TRACKPOINTSIZE );
          popMatrix();

      }

  }

  void drawNumber(){

      String txt = Integer.toString( this.num );

      PFont f = createFont( "Arial", 36, true );
      float fSize = cfg.NODE_TEXT_SIZE * cfg.SCREEN_RESOLUTION / 3;
      textAlign(CENTER, CENTER);
      textFont( f, fSize );

      VectorScreen screenPosParticle = this.position.transToScreen();
      float xParticle = screenPosParticle.x;
      float yParticle = screenPosParticle.y - cfg.SIMULATION_RESOLUTION * 0.1;

      fill( 0 );
      stroke( 0 );
      text( txt, xParticle, yParticle );

  }

  void drawVelocity(){

      VectorCoord v = discVelocity.copy();
      float maxValue = 2;
      color col = 0;

      VectorCoord vector = v.copy();

      VectorScreen screenPosParticle = this.position.transToScreen();
      float xParticle = screenPosParticle.x;
      float yParticle = screenPosParticle.y;

      if( vector.x != 0 && vector.y != 0){

          // First discretize len to particle size radius
          float disc = vector.mag() * maxValue;
          float discLen = disc * cfg.PARTICLE_SIZE_COORDINATE * 200;

          float x1 = xParticle;
          float y1 = yParticle;
          float x2 = xParticle + discLen * vector.x;
          float y2 = yParticle - discLen * vector.y;

          fill( col );
          stroke( col );
          strokeWeight( 2 );
          pushMatrix();
          line( x1, y1, x2, y2 );
          popMatrix();
          strokeWeight( 1 );

      }

  }

  void drawDirection( VectorCoord v, float maxValue, color col ){

      VectorScreen pos = this.position.transToScreen();

      float disc = v.copy().mag() / maxValue;

      if( cfg.SIM_SHOW_EQUAL_STEERING ){

          disc = 1;

      }

      v.normalize();
      VectorCoord vector = v.copy();

      if( ( vector.mag() != 0 ) || vector.x != 0 && vector.y != 0 ){

          //disc = 1;
          float discLen = disc * cfg.PARTICLE_SIZE / 2;

          float x1 = pos.x;
          float y1 = pos.y;
          float x2 = pos.x + discLen * vector.x;
          float y2 = pos.y - discLen * vector.y;

          fill( col );
          stroke( col );
          strokeWeight( 2 );
          pushMatrix();
          line( x1, y1, x2, y2 );
          popMatrix();
          strokeWeight( 1 );

      }

  }

  void drawOnlyParticle(){

      // Transfer position from coordinate values to screen values
      VectorScreen screenPos = this.position.transToScreen();
      float x = screenPos.x;
      float y = screenPos.y;

      color fillColor = c;
      if( cfg.SIM_SHOW_PARTICLE_BATTERY ){

          color startColor = c;
          color endColor = color( 255, 255, 255 );

          float colorValue = map( this.battery, 0, cfg.PARTICLE_BATTERY, 1, 0); // Generate a percentage value

          fillColor = lerpColor( startColor, endColor, colorValue );

      }

      fill( fillColor );
      strokeWeight( 2 );
      stroke( c );
      pushMatrix();
      ellipseMode(CENTER);
      ellipse( x, y, cfg.PARTICLE_SIZE, cfg.PARTICLE_SIZE );
      popMatrix();
      strokeWeight( 1 );

      if( cfg.SIM_SHOW_NUMBERS ){

          this.drawNumber();

      }

  }

  void draw() {

      if( cfg.SIM_SHOW_TRACE ){
        this.drawPositionList();
      }

      // Transfer position from coordinate values to screen values
      VectorScreen screenPos = this.position.transToScreen();
      float x = screenPos.x;
      float y = screenPos.y;

      color fillColor = c;
      if( cfg.SIM_SHOW_PARTICLE_BATTERY ){

          color startColor = c;
          color endColor = color( 255, 255, 255 );

          float colorValue = map( this.battery, 0, cfg.PARTICLE_BATTERY, 1, 0); // Generate a percentage value

          fillColor = lerpColor( startColor, endColor, colorValue );

      }

      fill( fillColor );
      strokeWeight( 2 );
      stroke( c );
      pushMatrix();
      ellipseMode(CENTER);
      ellipse( x, y, cfg.PARTICLE_SIZE, cfg.PARTICLE_SIZE );
      popMatrix();
      strokeWeight( 1 );

      if( cfg.SIM_SHOW_NUMBERS ){

          this.drawNumber();

      }


  }


}
