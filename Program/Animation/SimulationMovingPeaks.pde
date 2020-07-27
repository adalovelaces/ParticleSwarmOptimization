class MovingPeaks{

    String pfunc;
    float nPeaks;
    float min_coord;
    float max_coord;
    float min_height;
    float max_height;
    float uniform_height;
    float min_width;
    float max_width;
    float uniform_width;
    float lambda;
    float move_severity;
    float height_severity;
    float width_severity;
    float number_severity;
    float period;

    int scenarioNum;
    Scenario sc;
    ArrayList<Peak> peakList;

    float minPeaks;
    float maxPeaks;

    Float optimumObject;

    VectorCoord maxPosition;
    VectorCoord minPosition;
    float maxValue;
    float minValue;

    MovingPeaks( int _scenario ){

        this.scenarioNum = _scenario;
        this.sc = new Scenario( _scenario );

        this.init();
        this.initPeaks();

    }

    // INITIALISATION

    void init(){

        this.minPeaks = this.nPeaks;
        this.maxPeaks = this.nPeaks;
        this.number_severity = 0.1; //[TODO] unknown?

        this.optimumObject = null;

        /* TODO

        try:
               if len(pfunc) == npeaks:
                   self.peaks_function = pfunc
               else:
                   self.peaks_function = self.random.sample(pfunc, npeaks)
               self.pfunc_pool = tuple(pfunc)
           except TypeError:
               self.peaks_function = list(itertools.repeat(pfunc, npeaks))
               self.pfunc_pool = (pfunc,)

        */
    }

    void initPeaks(){

        this.peakList = new ArrayList<Peak>();

        for( int i = 0; i < sc.nPeaks; i++ ){

            // Create peak
            Peak p = new Peak( this.scenarioNum );

            // Add peak to list
            this.peakList.add( p );

        }

        this.calcMinPosition();
        //this.calcMaxPosition();

    }

    // GETTER

    VectorCoord getMaxPosition(){

        return this.maxPosition.copy();

    }

    VectorCoord getMinPosition(){

        return this.minPosition.copy();

    }

    ArrayList<Peak> getAllPeaks(){

        return this.peakList;

    }

    // DEFINE BASIS FUNCTIONS

    float functionCone( VectorCoord individualPos ){

        float sum;
        float value;
        float result = 0;

        for( Peak p : this.peakList ){

            sum = 0;
            sum += Math.pow( individualPos.x - p.pos.x, 2 );
            sum += Math.pow( individualPos.y - p.pos.y, 2 );

            value = p.peakHeight - p.peakWidth * (float) Math.sqrt( sum );
            value = - value;

            if( value < result ){

                result = value;

            }

        }

        return result;

    }

    float function1( VectorCoord individualPos ){

        float sum;
        float value;
        float result = 0;

        for( Peak p : this.peakList ){

            sum = 0;
            sum += Math.pow( individualPos.x - p.pos.x, 2 );
            sum += Math.pow( individualPos.y - p.pos.y, 2 );

            value = p.peakHeight / ( 1 + p.peakWidth * (float) Math.sqrt( sum ) );
            value = -value;

            if( value < result ){

                result = value;

            }

        }

        return result;

    }

    // EVALUATION

    float evaluate( VectorCoord individualPos ){

        float fitness = -1000;

        if( sc.pfunc == "cone" )        fitness = this.functionCone( individualPos.copy() );
        if( sc.pfunc == "function1" )   fitness = this.function1( individualPos.copy() );

        if( sc.bfunc.equals("10") && fitness < 10 ){

            fitness = 10;

        }

        return fitness;

    }

    // HELPER

    void calcMaxPosition(){

        float maxValue = 0;
        VectorCoord maxPos = new VectorCoord( 0, 0 );

        for( Peak p : this.peakList ){

            float value = this.evaluate( p.pos.copy() );

            if( value > maxValue ){

                maxValue = value;
                maxPos = p.pos.copy();

            }

        }

        this.maxPosition = maxPos.copy();

    }

    void calcMinPosition(){

        float minValue = 0;
        VectorCoord minPos = new VectorCoord( 0, 0 );

        for( Peak p : this.peakList ){

            float value = this.evaluate( p.pos.copy() );

            if( value > maxValue ){

                minValue = value;
                minPos = p.pos.copy();

            }

        }

        this.minPosition = minPos.copy();

    }


    // CHANGE FUNCTIONS

    void changePeaks(){

        this.changeNumberOfPeaks();

        for( Peak p : this.peakList ){

            p.changePosition();
            p.changeHeight();
            p.changeWidth();

        }

        this.optimumObject = null;
        //this.calcMaxPosition();
        this.calcMinPosition();

    }

    void changeNumberOfPeaks(){

        Random rand = new Random();

        float len = this.nPeaks;

        float u = rand.nextFloat();
        float r = this.maxPeaks - this.minPeaks;
        float num = (int) Math.round( r * u * this.number_severity );

        if( u < 0.5 ){

            u = rand.nextFloat();
            float n = min( ( this.nPeaks - this.minPeaks ), num );

            for( int i = 0; i < n; i++ ){

                // Delete random peak
                float idx = rand.nextInt() * this.peakList.size();
                this.peakList.remove( idx );

            }

        }

        else{

            u = rand.nextFloat();
            float n = min( ( this.maxPeaks - this.nPeaks ), num );

            for( int i = 0; i < n; i++ ){

                Peak p = new Peak( this.scenarioNum );

                this.peakList.add( p );

            }

        }

    }

}

class Scenario{

    String pfunc;
    String bfunc;
    float nPeaks;
    float min_coord;
    float max_coord;
    float min_height;
    float max_height;
    float uniform_height;
    float min_width;
    float max_width;
    float uniform_width;
    float lambda;
    float move_severity;
    float height_severity;
    float width_severity;
    float number_severity;
    float period;

    Scenario( int _scenario ){

        switch( _scenario ){
            case 1:
                this.setScenario1();
                break;
            case 2:
                this.setScenario2();
                break;
            case 3:
                this.setScenario3();
                break;
            default:
                break;
        }

    }

    void setScenario1(){

        this.pfunc = "function1";
        this.bfunc = "none";
        this.nPeaks = 5;
        this.min_coord = 0.0;
        this.max_coord = 100.0;
        this.min_height = 30.0;
        this.max_height = 70.0;
        this.uniform_height = 50.0;
        this.min_width = 0.0001;
        this.max_width = 0.2;
        this.uniform_width = 0.1;
        this.lambda = 0.0;
        this.move_severity = 1.0;
        this.height_severity = 7.0;
        this.width_severity = 0.01;
        this.period = 5000;

    }

    void setScenario2(){

        this.pfunc = "cone";
        this.bfunc = "none";
        this.nPeaks = 10;
        this.min_coord = 0.0;
        this.max_coord = 100.0;
        this.min_height = 30.0;
        this.max_height = 70.0;
        this.uniform_height = 50.0;
        this.min_width = 1.0;
        this.max_width = 12.0;
        this.uniform_width = 0.0;
        this.lambda = 0.5;
        this.move_severity = 1.5;
        this.height_severity = 7.0;
        this.width_severity = 1.0;
        this.period = 5000;

    }

    void setScenario3(){

        this.pfunc = "cone";
        this.bfunc = "10";
        this.nPeaks = 50;
        this.min_coord = 0.0;
        this.max_coord = 100.0;
        this.min_height = 30.0;
        this.max_height = 70.0;
        this.uniform_height = 0.0;
        this.min_width = 1.0;
        this.max_width = 12.0;
        this.uniform_width = 0.0;
        this.lambda = 0.5;
        this.move_severity = 1.0;
        this.height_severity = 1.0;
        this.width_severity = 0.5;
        this.period = 1000;

    }

}

class Peak{

    Scenario sc;
    VectorCoord pos;
    VectorCoord lastChangeVector;
    float peakHeight;
    float peakWidth;

    Peak( int _scenario ){

        this.sc = new Scenario( _scenario );
        this.init();

    }

    void init(){

        Random r = new Random();

        // Get peak position

        float x = r.nextFloat() * ( ( sc.max_coord - sc.min_coord ) + sc.min_coord );
        float y = r.nextFloat() * ( ( sc.max_coord - sc.min_coord ) + sc.min_coord );

        this.pos = new VectorCoord( x, y );

        // Get peak width and height

        this.peakHeight = sc.uniform_height;
        this.peakWidth = sc.uniform_width;

        if( sc.uniform_height == 0 ){
            this.peakHeight = r.nextFloat() * ( ( sc.max_height - sc.min_height ) + sc.min_height );
        }

        if( sc.uniform_width == 0 ){
            this.peakWidth = r.nextFloat() * ( ( sc.max_width - sc.min_width ) + sc.min_width );
        }

        // Get peak last change vector

        float lvX = r.nextFloat() - 0.5;
        float lvY = r.nextFloat() - 0.5;
        this.lastChangeVector = new VectorCoord( lvX, lvY );

    }

    void changePosition(){

        Random rand = new Random();
        float shiftX = 0;
        float shiftY = 0;
        float shiftLength = 0;
        VectorCoord shift = new VectorCoord( 0, 0 );

        shiftX = rand.nextFloat() - 0.5;
        shiftY = rand.nextFloat() - 0.5;
        shift = new VectorCoord( shiftX, shiftY );
        shiftLength = this.getShiftLength( shift );

        shiftX = shiftLength * ( 1 - sc.lambda ) * shift.x + sc.lambda * this.lastChangeVector.x;
        shiftY = shiftLength * ( 1 - sc.lambda ) * shift.y + sc.lambda * this.lastChangeVector.y;
        shift = new VectorCoord( shiftX, shiftY );
        shiftLength = this.getShiftLength( shift );

        shiftX = shift.x * shiftLength;
        shiftY = shift.y * shiftLength;
        shift = new VectorCoord( shiftX, shiftY );

        VectorCoord posCopy = this.pos.copy();
        VectorCoord shiftCopy = shift.copy();
        VectorCoord newCoord = this.pos.copy();
        newCoord.add( shiftCopy );

        float newPosX = newCoord.copy().x;
        if( newCoord.x < sc.min_coord )   newPosX = 2 * sc.min_coord - posCopy.x - shiftCopy.x;
        if( newCoord.x > sc.max_coord )   newPosX = 2 * sc.max_coord - posCopy.x - shiftCopy.x;

        float newPosY = newCoord.copy().y;
        if( newCoord.y < sc.min_coord )   newPosY = 2 * sc.min_coord - posCopy.y - shiftCopy.y;
        if( newCoord.y > sc.max_coord )   newPosY = 2 * sc.max_coord - posCopy.y - shiftCopy.y;

        VectorCoord newPos = new VectorCoord( newPosX, newPosY );

        float newFinalX = shiftCopy.x;
        if( newCoord.x < sc.min_coord )   newFinalX = ( -1 ) * shiftCopy.x;
        if( newCoord.x > sc.max_coord )   newFinalX = ( -1 ) * shiftCopy.x;

        float newFinalY = shiftCopy.y;
        if( newCoord.y < sc.min_coord )   newFinalY = ( -1 ) * shiftCopy.y;
        if( newCoord.y > sc.max_coord )   newFinalY = ( -1 ) * shiftCopy.y;

        VectorCoord newFinal = new VectorCoord( newFinalX, newFinalY );

        this.pos = newPos.copy();
        this.lastChangeVector = newFinal.copy();

    }

    void changeHeight(){

        Random rand = new Random();

        float change = (float) rand.nextGaussian() * sc.height_severity;
        float newValue = change + this.peakHeight;

        if( newValue < sc.min_height )    newValue = 2 * sc.min_height - this.peakHeight - change;
        if( newValue > sc.max_height )    newValue = 2 * sc.max_height - this.peakHeight - change;

        this.peakHeight = newValue;

    }

    void changeWidth(){

        Random rand = new Random();

        float change = (float) rand.nextGaussian() * sc.width_severity;
        float newValue = change + this.peakWidth;

        if( newValue < sc.min_width )    newValue = 2 * sc.min_width - this.peakWidth - change;
        if( newValue > sc.max_width )    newValue = 2 * sc.max_width - this.peakWidth - change;

        this.peakWidth = newValue;

    }

    // HELPER

    float getShiftLength(VectorCoord shift){

        float shiftLength = (float) ( Math.pow( shift.x, 2 ) + Math.pow( shift.y, 2 ) );

        if( shiftLength > 0 ){

            shiftLength = sc.move_severity / (float) Math.sqrt( shiftLength );

        }
        else{

            shiftLength = 0;

        }

        return shiftLength;

    }


}
