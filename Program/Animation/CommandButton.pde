public interface ButtonCommand{

    public void execute();

}

public class PrintCommand implements ButtonCommand{

    public void execute(){
        println("Test");
    }

}


public class ShowCommand implements ButtonCommand{

    String data;

    ShowCommand( Object data ){

        this.data = (String) data;

    }

    public void execute(){

        if( this.data.equals( "Trace" ) ){
          cfg.SIM_SHOW_TRACE = !cfg.SIM_SHOW_TRACE;
        }

        if( this.data.equals( "Battery" ) ){
          cfg.SIM_SHOW_PARTICLE_BATTERY = !cfg.SIM_SHOW_PARTICLE_BATTERY;
        }

        if( this.data.equals( "Connections" ) ){
          cfg.SIM_SHOW_PARTICLE_CONNECTIONS = !cfg.SIM_SHOW_PARTICLE_CONNECTIONS;
        }

        if( this.data.equals( "Laser" ) ){
          cfg.SIM_SHOW_LASER = !cfg.SIM_SHOW_LASER;
        }

    }

}


public class SelectRadiusCommand implements ButtonCommand{

    int data;

    SelectRadiusCommand( Object data ){

        this.data = (int) data;

    }

    public void execute(){

        cfg.PARTICLE_COMMUNICATION_RADIUS = (int) this.data;
        simulation = new Simulation();

    }

}

public class SelectObjectiveFunctionCommand implements ButtonCommand{

    int data;

    SelectObjectiveFunctionCommand( Object data ){

        this.data = (int) data;

    }

    public void execute(){

        cfg.SIM_VALUEFIELD_NUM = (int) this.data;
        simulation = new Simulation();

    }

}


public class SelectVectorFieldCommand implements ButtonCommand{

    int data;

    SelectVectorFieldCommand( Object data ){

        this.data = (int) data;

    }

    public void execute(){

        cfg.SIM_FLOWFIELD_NUM = (int) this.data;
        simulation = new Simulation();

    }

}

public class SelectSwarmCommand implements ButtonCommand{

    String swarm;

    SelectSwarmCommand( Object data ){

        this.swarm = String.valueOf( data );

    }

    public void execute(){

        cfg.INIT_PSO     = false;
        cfg.INIT_ZPSO    = false;
        cfg.INIT_PPSO    = false;

        if( this.swarm == "PSO" )       cfg.INIT_PSO     = true;
        if( this.swarm == "ZPSO" )      cfg.INIT_ZPSO    = true;
        if( this.swarm == "PPSO" )      cfg.INIT_PPSO    = true;

        simulation = new Simulation();

    }

}

public class StartCommand implements ButtonCommand{

    public void execute(){

        simulation = new Simulation();

    }

}

public class PauseCommand implements ButtonCommand{

    public void execute(){

        simulation.pause();

    }

}
