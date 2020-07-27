
public interface ParticleCommand{

    public void execute( int num, float battery, ArrayList<Particle> neighbors );

}


public class SelectParticle implements ParticleCommand{


    public void execute( int num, float battery, ArrayList<Particle> neighbors ){

        String neighborString = "";

        for( Particle p : neighbors ){

            neighborString += Integer.toString( p.getNum() ) + " ";

        }

        println( "Clicked " + Integer.toString( num ) + " Battery: " + Float.toString( battery )  + " Neighbor: " + neighborString );

    }

}
