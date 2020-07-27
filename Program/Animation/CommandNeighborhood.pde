public interface CommandNeighborhood{

    public void create( Particle[] swarm );

}

public class CreateNearestNeighbors implements CommandNeighborhood{

    int dist;

    CreateNearestNeighbors( int _dist ){

        this.dist = _dist;

    }

    public void create( Particle[] swarm ){

        println("Create");

    }

}
