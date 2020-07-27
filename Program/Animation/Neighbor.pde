class Neighbor implements Comparable{

    private Particle particle;
    private float value;

    Neighbor( Particle p, float value ){

        this.particle = p;
        this.value = value;

    }

    public float getValue(){

        return this.value;

    }

    public Particle getParticle(){

        return this.particle;

    }

    public int getNum(){

        return this.particle.getNum();

    }

    public String toString(){

        return "ParticleNum: " + this.getNum() + " Value: " + this.value + "\n";

    }

    @Override
    public int compareTo( Object compareNeighbor ) {

		float compareValue = ( (Neighbor) compareNeighbor).getValue();

        if( compareValue > this.value ) return -1;
        if( compareValue < this.value ) return 1;
        return 0;

	}

}
