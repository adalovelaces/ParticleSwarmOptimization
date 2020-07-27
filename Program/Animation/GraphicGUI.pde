class GraphicGUI{

    private GraphicView viewButtons;
    private ArrayList<GraphicView> allViews;

    GraphicGUI(){

        allViews = new ArrayList<GraphicView>();

        createGraphicViews();

    }

    void draw(){

        for( GraphicView view : allViews ){

            view.draw();

        }

    }

    void onMousePressed(){

        for( GraphicView view : allViews ){

            GraphicObject button = view.getObjectUnderMouse();

            if( button != null ){

                button.execute();

            }

        }

    }

    void createGraphicViews(){

        GraphicView viewButtons = createViewButtons();

        allViews.add( viewButtons );

    }

    GraphicView createViewButtons(){

        //[TODO] move to config

        float margin = cfg.MARGIN / 2;

        int startX = (int) ( width * 0.61 );
        int startY = (int) margin;

        int sizeX = (int) ( width * 0.1 );
        int sizeY = (int) ( height - margin * 2 );

        VectorScreen pos = new VectorScreen( startX, startY );
        VectorScreen size = new VectorScreen( sizeX, sizeY );

        VectorScreen posRight = new VectorScreen( startX + sizeX / 2, startY );

        GraphicView view = new GraphicView( "ButtonView", pos.copy(), size.copy() );
        pos.y += margin;

        //[TODO] move to config

        int distLabel = 20;
        int distNormalButton = 40;
        int distSmallButton = 20;
        int distVerySmallButton = 20;

        GraphicButtonNormal btnStart = new GraphicButtonNormal( "ButtonStart", pos.copy(), size.copy(), "Start", new StartCommand() );
        pos.y += distNormalButton + margin;

        GraphicButtonNormal btnPause = new GraphicButtonNormal( "ButtonPause", pos.copy(), size.copy(), "Play/Pause", new PauseCommand() );
        pos.y += distNormalButton + margin;

        pos.y += margin;

        String txt = "Iteration: ";
        GraphicLabel labelIteration = new GraphicLabel( "LabelIteration", pos.copy(), size.copy(), txt );
        pos.y += distLabel + margin;

        txt = "GBest: ";
        GraphicLabel labelGBest = new GraphicLabel( "LabelGBest", pos.copy(), size.copy(), txt );
        pos.y += distLabel + margin;

        txt = "NH: ";
        GraphicLabel labelNeighborhood = new GraphicLabel( "LabelNeighborhood", pos.copy(), size.copy(), txt );
        pos.y += distLabel + margin;

        txt = "OF: ";
        GraphicLabel labelObjectiveFunction = new GraphicLabel( "LabelObjectiveFunction", pos.copy(), size.copy(), txt );
        pos.y += distLabel + margin;

        txt = "VF: ";
        GraphicLabel labelVectorField = new GraphicLabel( "LabelVectorField", pos.copy(), size.copy(), txt );
        pos.y += distLabel + margin;

        txt = "Radius: ";
        GraphicLabel labelRadius = new GraphicLabel( "LabelRadius", pos.copy(), size.copy(), txt );
        pos.y += distLabel + margin;

        pos.y += margin;

        GraphicButtonSwarm btnPso = new GraphicButtonSwarm( "ButtonPso", pos.copy(), size.copy(), "PSO", cfg.COLOR_SWARM_PSO, new SelectSwarmCommand( "PSO" ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSwarm btnZpso = new GraphicButtonSwarm( "ButtonZpso", pos.copy(), size.copy(), "ZPSO", cfg.COLOR_SWARM_ZPSO, new SelectSwarmCommand( "ZPSO" ));
        pos.y += distSmallButton + margin;

        GraphicButtonSwarm btnPpso = new GraphicButtonSwarm( "ButtonPpso", pos.copy(), size.copy(), "PPSO", cfg.COLOR_SWARM_PPSO, new SelectSwarmCommand( "PPSO" ));
        pos.y += distSmallButton + margin;

        pos.y += margin;

        GraphicButtonSmall btnOF1 = new GraphicButtonSmall( "ButtonOF1", pos.copy(), size.copy(), "Sphere", new SelectObjectiveFunctionCommand( 1 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnOF2 = new GraphicButtonSmall( "ButtonOF2", pos.copy(), size.copy(), "Rosenbrock", new SelectObjectiveFunctionCommand( 2 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnOF3 = new GraphicButtonSmall( "ButtonOF3", pos.copy(), size.copy(), "Ackley", new SelectObjectiveFunctionCommand( 3 ) );
        pos.y += distSmallButton + margin;

        pos.y += margin;

        GraphicButtonSmall btnVF1 = new GraphicButtonSmall( "ButtonVF1", pos.copy(), size.copy(), "VF1: Cross", new SelectVectorFieldCommand( 1 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnVF2 = new GraphicButtonSmall( "ButtonVF2", pos.copy(), size.copy(), "VF2: Rotation", new SelectVectorFieldCommand( 2 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnVF4 = new GraphicButtonSmall( "ButtonVF4", pos.copy(), size.copy(), "VF3: Fall", new SelectVectorFieldCommand( 4 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnVF6 = new GraphicButtonSmall( "ButtonVF6", pos.copy(), size.copy(), "VF4: Bi", new SelectVectorFieldCommand( 6 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnVF10 = new GraphicButtonSmall( "ButtonVF10", pos.copy(), size.copy(), "VF5: Real1", new SelectVectorFieldCommand( 10 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnVF12 = new GraphicButtonSmall( "ButtonVF12", pos.copy(), size.copy(), "VF6: Real2", new SelectVectorFieldCommand( 12 ) );
        pos.y += distSmallButton + margin;

        pos.y += margin;

        GraphicButtonSmall btnR1 = new GraphicButtonSmall( "ButtonR1", pos.copy(), size.copy(), "Radius: 2", new SelectRadiusCommand( 2 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnR2 = new GraphicButtonSmall( "ButtonR2", pos.copy(), size.copy(), "Radius: 5", new SelectRadiusCommand( 5 ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnR3 = new GraphicButtonSmall( "ButtonR3", pos.copy(), size.copy(), "Radius: 30", new SelectRadiusCommand( 30 ) );
        pos.y += distSmallButton + margin;

        pos.y += margin;

        GraphicButtonSmall btnShow1 = new GraphicButtonSmall( "ButtonShow1", pos.copy(), size.copy(), "Trace On-Off", new ShowCommand( "Trace" ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnShow2 = new GraphicButtonSmall( "ButtonShow2", pos.copy(), size.copy(), "Network On-Off", new ShowCommand( "Connections" ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnShow3 = new GraphicButtonSmall( "ButtonShow3", pos.copy(), size.copy(), "Laser On-Off", new ShowCommand( "Laser" ) );
        pos.y += distSmallButton + margin;

        GraphicButtonSmall btnShow4 = new GraphicButtonSmall( "ButtonShow4", pos.copy(), size.copy(), "Battery On-Off", new ShowCommand( "Battery" ) );
        pos.y += distSmallButton + margin;


        pos.y += margin;

        view.addObject( labelIteration );
        view.addObject( labelGBest );
        view.addObject( labelNeighborhood );
        view.addObject( labelObjectiveFunction );
        view.addObject( labelVectorField );
        view.addObject( labelRadius );
        view.addClickableObject( btnStart );
        view.addClickableObject( btnPause );
        view.addClickableObject( btnPso );
        view.addClickableObject( btnZpso );
        view.addClickableObject( btnPpso );
        view.addClickableObject( btnOF1 );
        view.addClickableObject( btnOF2 );
        view.addClickableObject( btnOF3 );
        view.addClickableObject( btnVF1 );
        view.addClickableObject( btnVF2 );
        view.addClickableObject( btnVF4 );
        view.addClickableObject( btnVF6 );
        view.addClickableObject( btnVF10 );
        view.addClickableObject( btnVF12 );
        view.addClickableObject( btnR1 );
        view.addClickableObject( btnR2 );
        view.addClickableObject( btnR3 );
        view.addClickableObject( btnShow1 );
        view.addClickableObject( btnShow2 );
        view.addClickableObject( btnShow3 );
        view.addClickableObject( btnShow4 );


        return view;

    }
}
