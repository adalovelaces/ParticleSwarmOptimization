class ParticleCoalition implements Comparable{

    private Particle searcher;
    private ArrayList<Particle> particle;
    private VectorCoord center;
    private float value;

    ParticleCoalition( Particle searcher, ArrayList<Particle> particle ){

        this.searcher = searcher;
        this.particle = particle;
        this.center = new VectorCoord( 0, 0 );
        this.value = -1;

        this.calcCenter();

    }

    public float size(){

        return this.particle.size();

    }

    public float getValue(){

        return this.value;

    }

    public String getHashMapKey(){

        this.sort();

        String hash = "";
        for( Particle p : this.particle ){

            hash += p.toString();

        }

        return hash;

    }

    public void sort(){

        Collections.sort( this.particle );

    }

    public void setValue( float v ){

        this.value = v;

    }

    public VectorCoord getCenter(){

        return this.center.copy();

    }

    public VectorCoord getGBestPosition(){

        float bestValue = cfg.PSO_INIT;
        VectorCoord bestPosition = new VectorCoord( 0, 0 );

        for( Particle p : this.particle ){

            if( p.gBestValue < bestValue ){

                bestValue = p.gBestValue;
                bestPosition = p.gBestPosition.copy();

            }

        }

        return bestPosition.copy();

    }

    public ArrayList<Particle> getParticle(){

        return this.particle;

    }

    public String toString(){

        String particleList = "";
        for( Particle p : particle ){

            particleList += p.getNum() + " ";

        }
        return "Coalition: {" + particleList + "} Center: " + this.getCenter() + " Value: " + this.value + "\n";

    }

    private void calcCenter(){

        float centerX = 0;
        float centerY = 0;

        for( Particle p : this.particle ){

            centerX += p.position.copy().x;
            centerY += p.position.copy().y;

        }

        centerX += this.searcher.position.copy().x;
        centerY += this.searcher.position.copy().y;

        centerX = centerX / ( this.particle.size() + 1 );
        centerY = centerY / ( this.particle.size() + 1 );

        this.center = new VectorCoord( centerX, centerY );

    }

    @Override
    public int compareTo( Object compareNeighbor ) {

		float compareValue = ( (Neighbor) compareNeighbor).getValue();

        if( compareValue > this.value ) return -1;
        if( compareValue < this.value ) return 1;
        return 0;

	}

}
