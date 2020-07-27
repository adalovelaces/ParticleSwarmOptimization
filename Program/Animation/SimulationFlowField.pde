class FlowField extends GraphicObject{

  private VectorCoord [][] grid;
  private VectorScreen gridSize;
  private int num;
  private float maxLength;
  private float minLength;
  private int cols;
  private int rows;

  private float[][] importedWindU;
  private float[][] importedWindV;

  /*------------------------------------------------------------*/
  /*                           CONSTRUCTOR                      */
  /*------------------------------------------------------------*/

  FlowField( int _num, String _name, VectorScreen _pos, VectorScreen _size ) {

      super( _name, _pos, _size );

      this.cols = cfg.SIMULATION_COLUMNS;
      this.rows = cfg.SIMULATION_ROWS;

      int gridCell = cfg.SIMULATION_GRID_SIZE / 2;
      this.gridSize = new VectorScreen( gridCell, gridCell );

      this.num = _num;
      this.maxLength = 0;
      this.minLength = 1000;
      this.grid = new VectorCoord[ cfg.SIMULATION_COLUMNS ][ cfg.SIMULATION_ROWS ];

      this.init();

  }

  /*------------------------------------------------------------*/
  /*                           INITIALISATION                   */
  /*------------------------------------------------------------*/

  void init(){

      if( this.num >= 10 ){

          this.importWindData();

      }

      this.initGrid();

      this.initMinMaxLength();

      if( this.num >= 10 ){

          this.scaleWindData();

      }

  }

  void initGrid(){

      for( int col = 0; col < cfg.SIMULATION_COLUMNS; col++ ) {
          for( int row = 0; row < cfg.SIMULATION_ROWS; row++ ) {

              // Get flow
              VectorGrid gridPos = new VectorGrid( col, row );
              VectorCoord coordPos = gridPos.transToCoordinate();

              VectorCoord flow = this.getUnscaledFlow( coordPos );

              // Set flow in this cell
              this.grid[ col ][ row ] = flow;

          }
      }

  }

  void initMinMaxLength(){

      if( this.num < 10 ){

          this.setMinMaxLengthLinear();

      }
      else{

          this.setMinMaxLengthDiscrete();

      }

  }

  void importWindData(){

      String filePath = System.getProperty("user.dir");
      File file = new File( filePath );
      String absoluteFilePath = file.getAbsolutePath();
      String path = Paths.get( absoluteFilePath ).getParent().toString();

      String dataPath = path;

      dataPath = path.replace( "\\", "/" );

      dataPath = cfg.PATH_FOLDER;
      dataPath += "/Data/";

      switch( this.num ){

        case 10:
            dataPath += cfg.PATH_WIND1 + ".txt";
            break;
        case 11:
            dataPath += cfg.PATH_WIND2 + ".txt";
            break;
        case 12:
            dataPath += cfg.PATH_WIND3 + ".txt";
            break;
        default:
            dataPath += cfg.PATH_WIND1 + ".txt";
            break;
      }

      this.importedWindU = this.importWindU( dataPath );
      this.importedWindV = this.importWindV( dataPath );

  }

  void scaleWindData(){

      for( int i = 0; i < this.importedWindU.length; i++ ){
          for( int j = 0; j < this.importedWindV.length; j++ ){

              float u = this.importedWindU[ i ][ j ];
              float v = this.importedWindV[ i ][ j ];

              VectorCoord unscaledFlow = new VectorCoord( u, v );
              VectorCoord scaledFlow = this.scaleFlow( unscaledFlow.copy() );

              //scaledFlow.x = (float)((int)( scaledFlow.x *100f))/100f;
              //scaledFlow.y = (float)((int)( scaledFlow.y *100f))/100f;

              this.importedWindU[ i ][ j ] = scaledFlow.x;
              this.importedWindV[ i ][ j ] = scaledFlow.y;

          }
      }


  }

  /*------------------------------------------------------------*/
  /*                           SETTER                           */
  /*------------------------------------------------------------*/

  void setMinMaxLengthLinear(){

      // First only use discrete/grid values
      this.setMinMaxLengthDiscrete();

      // Second put in max and min values in the funcions
      float minX = cfg.SIMULATION_MIN_X;
      float maxX = cfg.SIMULATION_MAX_X;
      float minY = cfg.SIMULATION_MIN_Y;
      float maxY = cfg.SIMULATION_MAX_Y;

      VectorCoord v1 = new VectorCoord( minX, minY );
      VectorCoord v2 = new VectorCoord( minX, maxY );
      VectorCoord v3 = new VectorCoord( maxX, minY );
      VectorCoord v4 = new VectorCoord( maxX, maxY );

      List<VectorCoord> list = new ArrayList<VectorCoord>();
      list.add( v1 );
      list.add( v2 );
      list.add( v3 );
      list.add( v4 );

      for( VectorCoord v : list ){

          float vMag = getUnscaledFlow( v ).mag();

          if( vMag < this.minLength ) this.minLength = vMag;
          if( vMag > this.maxLength ) this.maxLength = vMag;

      }


  }

  void setMinMaxLengthDiscrete(){

      for( int col = 0; col < cfg.SIMULATION_COLUMNS; col++ ){
          for( int row = 0; row < cfg.SIMULATION_ROWS; row++ ){

              float length = this.grid[ col ][ row ].mag();

              if( length > maxLength ) this.maxLength = length;

              if( length < minLength ) this.minLength = length;

          }
      }

  }

  /*------------------------------------------------------------*/
  /*                           GETTER                           */
  /*------------------------------------------------------------*/

  float getMaxLength(){
      return this.maxLength;
  }

  float getMinLength(){
      return this.minLength;
  }

  VectorCoord getFlow( VectorCoord vec ){

      return this.getFlow( vec.x, vec.y );

  }

  // Input: Coordinates
  VectorCoord getFlow( float posX,  float posY ){

      VectorCoord unscaledFlow = this.getUnscaledFlow( posX, posY );

      if( this.num >= 10 ){
          return this.getUnscaledFlow( posX, posY ); //Imported wind is already scaled
      }

      return this.scaleFlow( unscaledFlow.copy() );

  }

  VectorCoord getUnscaledFlow( VectorCoord pos ){

      return this.getUnscaledFlow( pos.x, pos.y );

  }

  VectorCoord getUnscaledFlow( float posX, float posY ){

      float x = posX;
      float y = posY;

      // Calculate the flow accordingly to the selected vector field
      switch( this.num ){

        case 1:
            return fnCross( x, y );
        case 2:
            return fnRotation( x, y );
        case 3:
            return fnSheared( x, y );
        case 4:
            return fnSimple( x, y );
        case 5:
            return fnTornado( x, y );
        case 6:
            return fnTwoDirections( x, y );
        case 7:
            return fnRandom( x, y );
        case 8:
            return fnMultiRotation( x, y );
        case 9:
            return fnVortex( x, y );
        case 10:
            return fnRealWorld( x, y );
        case 11:
            return fnRealWorld( x, y );
        case 12:
            return fnRealWorld( x, y );
        case 13:
            return fnRealWorld( x, y );
        default:
            return new VectorCoord( 0, 0 );

      }

  }

  VectorCoord scaleFlow( VectorCoord unscaledFlow ){

      float scaleFactor = ( unscaledFlow.mag() / this.maxLength ) * cfg.PARTICLE_FLOW_MAX;

      VectorCoord scaledFlow = unscaledFlow.copy();

      scaledFlow.normalize();
      scaledFlow.mult( scaleFactor );

      return scaledFlow;

  }

  /*------------------------------------------------------------*/
  /*                           DISPLAY                          */
  /*------------------------------------------------------------*/

  // Draw every vector
  void draw() {

      int iterAdd = 1;
      float scale = ( cfg.SIMULATION_GRID_SIZE ) - 2;

      if( cfg.SIMULATION_GRID_SIZE <= 30 ){

          iterAdd = (int) Math.floor( 30 / cfg.SIMULATION_GRID_SIZE );
          scale = scale * iterAdd;

      }

      // Standard representation as arrow in each grid cell
      if( this.num < 10 ){

          for ( int col = 0; col < cfg.SIMULATION_COLUMNS; col += iterAdd ) {
              for ( int row = 0; row < cfg.SIMULATION_ROWS; row += iterAdd ) {

                  VectorGrid gridPos = new VectorGrid( col, row );
                  this.drawVector( this.grid[ col ][ row ], gridPos, scale );

              }
          }

      }

      // Summarized representation as single arrow in each larger grid area

      if( this.num >= 10 ){

          if( cfg.SIM_SHOW_REAL_WORLD_GRID ){
              this.drawGridLines();
          }
          this.drawGridVectors();

      }

  }

  void drawGridVectors(){

      float x = cfg.SIMULATION_MIN_X;
      float y = cfg.SIMULATION_MAX_Y;

      while( y >= cfg.SIMULATION_MIN_Y ){

          x = cfg.SIMULATION_MIN_X;

          while( x < cfg.SIMULATION_MAX_X ){

              VectorCoord coordPos = new VectorCoord( x + cfg.FLOW_CELLS_X_SIZE / 2, y + cfg.FLOW_CELLS_Y_SIZE / 2 );
              VectorScreen screenPos = coordPos.transToScreen();

              float arrowsize = 7;
              pushMatrix();
              translate( screenPos.x, screenPos.y );

              stroke( cfg.COLOR_FLOWFIELD_VECTOR );

              // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
              VectorCoord flowVector = this.getFlow( x, y );
              PVector f = flowVector.transToPVector();

              rotate( -f.heading2D() );

              float scale = cfg.SIMULATION_GRID_SIZE + 5;

              // Calculate length of vector & scale it to be bigger or smaller if necessary
              float disc = flowVector.mag() / cfg.PARTICLE_FLOW_MAX;
              float discLen = disc * scale;
              float discArrow = disc * arrowsize + 0.5;

              // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
              line( 0, 0, discLen, 0 );
              line( discLen, 0, discLen - discArrow, + discArrow / 2 );
              line( discLen, 0, discLen - discArrow, - discArrow / 2 );
              popMatrix();

              x += cfg.FLOW_CELLS_X_SIZE;

          }


          y -= cfg.FLOW_CELLS_Y_SIZE;

      }

  }

  void drawGridLines(){

      float x = cfg.SIMULATION_MIN_X;
      float y = cfg.SIMULATION_MAX_Y;

      while( x < cfg.SIMULATION_MAX_X ){

          this.drawDashedLine( x, cfg.SIMULATION_MAX_Y, x, cfg.SIMULATION_MIN_Y );

          x += cfg.FLOW_CELLS_X_SIZE;

      }

      while( y > cfg.SIMULATION_MIN_Y ){

          this.drawDashedLine( cfg.SIMULATION_MIN_X, y, cfg.SIMULATION_MAX_X, y );

          y -= cfg.FLOW_CELLS_Y_SIZE;

      }

  }

  void drawDashedLine( float startX, float startY, float endX, float endY ){

      pushMatrix();

      VectorCoord startPos = new VectorCoord( startX, startY );
      VectorCoord endPos = new VectorCoord( endX, endY );

      // Translate to position to render vector
      VectorScreen screenStartPos = startPos.transToScreen();
      VectorScreen screenEndPos = endPos.transToScreen();

      stroke( cfg.COLOR_FLOWFIELD_GRIDLINES );

      int x = screenStartPos.x;
      int y = screenStartPos.y;
      int len = 10;

      while( x < screenEndPos.x ){

          line( x, y, x + len, y );

          x += 20;

      }

      while( y < screenEndPos.y ){

          line( x, y, x, y + len );

          y += 20;

      }

      popMatrix();

  }

  // Renders a vector object 'v' as an arrow and a position 'x,y'
  void drawVector( VectorCoord flowVector, VectorGrid gridPos, float scale ) {

      pushMatrix();

      float arrowsize = 4;

      // Translate to position to render vector
      VectorScreen screenPos = gridPos.transToScreen();
      float x = screenPos.x - ( cfg.SIMULATION_RESOLUTION ) + cfg.SIMULATION_GRID_SIZE;
      float y = screenPos.y - ( cfg.SIMULATION_RESOLUTION ) + cfg.SIMULATION_GRID_SIZE;

      translate( x, y );

      stroke( cfg.COLOR_FLOWFIELD_VECTOR );

      // Call vector heading function to get direction (note that pointing to the right is a heading of 0) and rotate
      PVector f = flowVector.transToPVector();
      rotate( -f.heading2D() );

      // Calculate length of vector & scale it to be bigger or smaller if necessary
      float disc = flowVector.mag() / this.maxLength;
      float discLen = disc * scale;
      float discArrow = disc * arrowsize + 0.5;

      // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
      line( 0, 0, discLen, 0 );
      line( discLen, 0, discLen - discArrow, + discArrow / 2 );
      line( discLen, 0, discLen - discArrow, - discArrow / 2 );
      popMatrix();

  }

  /*------------------------------------------------------------*/
  /*                        FUNCTIONS                           */
  /*------------------------------------------------------------*/

  VectorCoord fnSimple( float x, float y ){

      float u = 0;
      float v = -1;
      return new VectorCoord( u, v );

  }

  VectorCoord fnCross( float x, float y ){

      float u = y;
      float v = x;
      return new VectorCoord( u, v );

  }

  VectorCoord fnRotation( float x, float y ){

      float u = y * (-1);
      float v = x;
      return new VectorCoord( u, v );

  }

  VectorCoord fnSheared( float x, float y ){

      float u = x + y;
      float v = y;
      return new VectorCoord( u, v );

  }

  VectorCoord fnWave( float x, float y ){

      //(float) Math.toRadians(y);

      float u = sin( y );
      // float u = asin( a );
      float b = x * ( y - x );
      float v = cos( b );
      return new VectorCoord( u, v );

  }

  VectorCoord fnTornado( float x, float y ){

      float u = (-1) * x -y;
      float v = x;
      return new VectorCoord( u, v );

  }

  VectorCoord fnTwoDirections( float x, float y ){

      float u = -0.7*y;
      float v = 0;
      return new VectorCoord( u, v );

  }

  VectorCoord fnRandom( float x, float y ){

      float u = random( -1, 1 );
      float v = random( -1, 1 );

      return new VectorCoord( u, v );

  }

  VectorCoord fnMultiRotation( float x, float y ){

      float a = ( 4.0 / 30.0 ) * 2.0 * PI * y;
      float b = ( 4.0 / 30.0 ) * 2.0 * PI * x;
      float u = sin( a );
      float v = sin( b );

      return new VectorCoord( u, v );

  }

  VectorCoord fnVortex( float x, float y ){

      float a = ( 4.0 / 30.0 ) * ( x + ( 2.0 * y ) );
      float b = ( 4.0 / 30.0 ) * ( x - ( 2.0 * y ) );

      float u = cos( a );
      float v = sin( b );

      return new VectorCoord( u, v );

  }

  VectorCoord fnRealWorld( float x, float y ){

      float[][] windU = this.importedWindU;
      float[][] windV = this.importedWindV;

      float shiftedX = x - cfg.SIMULATION_MIN_X;
      float shiftedY = y - cfg.SIMULATION_MIN_Y;

      int xIndex = (int) ( shiftedX / cfg.FLOW_CELLS_X_SIZE );
      int yIndex = (int) ( shiftedY / cfg.FLOW_CELLS_Y_SIZE );

      float u = windU[ xIndex ][ yIndex ];
      float v = windV[ xIndex ][ yIndex ];

      return new VectorCoord( u, v );

  }

  /*------------------------------------------------------------*/
  /*                        HELPER                              */
  /*------------------------------------------------------------*/

  String getPathForNewestFile( String dirPath, String type ){

      File folder = new File( System.getProperty("user.home") + dirPath );
      File[] files = folder.listFiles();

      Arrays.sort(files, new Comparator<File>() {
  	       public int compare(File f1, File f2) {
				return Long.valueOf(f1.lastModified()).compareTo(
						f2.lastModified());
		   }
	  });

      return files[ files.length - 1].getAbsolutePath();

  }


  float[][] importWindU( String path ){

      return this.importCSV( path, "U" );

  }

  float[][] importWindV( String path ){

      return this.importCSV( path, "V" );

  }

  float[][] importCSV( String path, String section ){

      int numberOfValues = 60;
      float[][] values = new float[ numberOfValues ][ numberOfValues ];

      File file = new File( path );

      boolean read = false;
      Scanner scanner = null;

      if( file.exists() ){

          try {

              scanner = new Scanner( file );

              scanner.useDelimiter( "\n" );

              String firstChar = "-";
              String row = "";
              int count = 0;
              float[] cellValues = new float[ numberOfValues ];
              float value = 0;

              while( scanner.hasNext() ){

                  row = scanner.next();

                  // Check if a new section will be read

                  firstChar = row.substring(0,1);
                  if( firstChar.matches( "[A-Za-z ]*" ) ){

                      count = 0;
                      read = firstChar.equals( section ) ? true : false;
                      continue;

                  }

                  // Read a row of values (array) and store it in multidimensional result matrix

                  if( read ){

                      String [] cells = row.split(",");

                      cellValues = new float[ numberOfValues ];

                      for( int i = 0; i < cells.length; i++ ){

                          value = Float.parseFloat( cells[ i ] );
                          cellValues[ i ] = value;

                      }

                      values[ count ] = cellValues;
                      count++;

                  }

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

}
