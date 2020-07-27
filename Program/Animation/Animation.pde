
import java.util.Random;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Collections;
import java.util.Arrays;
import java.util.Set;
import java.util.HashSet;
import java.util.List;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.Scanner;
import java.util.Comparator;

import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.nio.file.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;

ConfigSimulation cfg;
Analysis analysis;
GraphicGUI gui;
FileSVG fileSVG;
Simulation simulation;
VectorCoord [][] grid;

int countIter;
int countFrames;
int delay;

float psoGBest;
long timeStart;

void settings(){

    cfg = new ConfigSimulation();

    size( 1610, 970 );

    String sysName = System.getProperty("os.name");

    if( sysName.contains( "Windows" ) ){
        cfg.WINDOWS_SYSTEM = true;
    }

    else if( sysName.contains( "Linux" ) ){
        cfg.WINDOWS_SYSTEM = false;
    }

    else{

        println("WARNING: SYSTEM NOT DETECTED");

    }



}

void setup(){

    grid = getRealGrid(); //vector field parameter

    if (cfg.ANALYSIS || args != null) {

        cfg.ANALYSIS = true;
        cfg.SIM_SHOW_SIMULATION = false;

        if( args == null ){

            args = new String [5];
            args[ 0 ] = "argu";
            args[ 1 ] = "";
            args[ 2 ] = str(cfg.ANALYSIS_RUNS);
            args[ 3 ] = str(cfg.ANALYSIS_ITERATION);
            args[ 4 ] = cfg.ANALYSIS_NH;

        }

        analysis = new Analysis( args );

    }

    gui = new GraphicGUI();

    if( cfg.SIM_SHOW_SIMULATION ){

        pixelDensity( displayDensity() );

    }



    if( cfg.SIM_SHOW_SIMULATION ){

        if( cfg.SIM_STORE_SVG ){
            fileSVG = new FileSVG( );
        }

        cfg.SIM_FLOWFIELD_NUM = 1;
        cfg.SIM_VALUEFIELD_NUM = 2;
        int index = 1;
        cfg.PARTICLE_NH_TITLE = cfg.ANALYSIS_NH_TITLE.get( index );

        simulation = new Simulation();

    }

}


void draw() {

    if( cfg.SIM_STORE_SVG && frameCount == 1 ){
        this.storeSVG();
        return;
    }

    if( cfg.SIM_SHOW_SIMULATION )   this.showSimulation();
    if( !cfg.SIM_SHOW_SIMULATION && frameCount == 1 )  analysis.run();

}

void keyPressed(){

  if (key == CODED) {

    if(keyCode==DOWN){
      println("\nQUIT\n");
      stop();
      exit();

    }

  }

}

void storeSVG(){

    background(cfg.COLOR_ENVIRONMENT);

    gui.draw();

    fileSVG.startExport();

    simulation.drawFlowField();
    delay(10);

    fileSVG.stopExport();

}

void showSimulation(){

    background(cfg.COLOR_ENVIRONMENT);

    gui.draw();

    delay = 1;

    while( !cfg.SIM_SHOW_CONTINUOUS && ( countFrames % cfg.SIMULATION_SUBITERATIONS != 0 || countFrames == 0 ) && !simulation.pause ){

        delay = 2;
        simulation.run();

    }

    simulation.run();

    simulation.draw();

    delay( cfg.SIM_SHOW_DELAY * delay );

}

void mousePressed(){

    gui.onMousePressed();

    simulation.onMousePressed();

}


VectorCoord[][] getRealGrid(){

    VectorCoord[][] grid = new VectorCoord[ cfg.SIMULATION_COLUMNS ][ cfg.SIMULATION_ROWS ];

    float minX = Math.abs(cfg.SIMULATION_MIN_X);
    float maxX = Math.abs(cfg.SIMULATION_MAX_X);

    float columnSizeInCoordinates = ( minX + maxX ) / cfg.SIMULATION_COLUMNS;

    float minY = Math.abs(cfg.SIMULATION_MIN_Y);
    float maxY = Math.abs(cfg.SIMULATION_MAX_Y);

    float rowSizeInCoordiantes = ( minY + maxY ) / cfg.SIMULATION_ROWS;

    for( int i = 0; i < cfg.SIMULATION_COLUMNS; i++ ){
        for( int j = 0; j < cfg.SIMULATION_ROWS; j++ ){

            float x = (float) i * columnSizeInCoordinates + cfg.SIMULATION_MIN_X; //Shift the minimum
            float y = (float) j * rowSizeInCoordiantes - cfg.SIMULATION_MAX_Y; //Shift the minimum

            grid[ i ][ j ] = new VectorCoord( x, -y );

        }
    }

    return grid;
}
