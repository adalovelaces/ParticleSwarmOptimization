class Interaction{

    private int size;
    private InteractionNode [] nodes;
    private int maxEdges;

    Interaction( int size ){

        this.size = size;
        this.nodes = new InteractionNode[ size ];
        this.maxEdges = 0;
        this.init();

    }

    void init(){

        int centerX = cfg.INTERACTION_AREA_X + cfg.INTERACTION_SIZE_X / 2  + cfg.MARGIN / 4;
        int centerY = cfg.INTERACTION_AREA_Y + cfg.INTERACTION_SIZE_Y / 2;

        float slice = (float) Math.PI;
        slice = 2 * slice / this.size;

        for( int i = 0; i < this.size; i++ ){

            float angle = slice * i;
            float radius = cfg.INTERACTION_SIZE_X / 2 * 0.8;

            int x = (int) Math.ceil( ( centerX + radius * Math.cos( angle ) ) );
            int y = (int) Math.ceil( ( centerY + radius * Math.sin( angle ) ) );

            radius = radius * 1.1;
            int xLabel = (int) Math.ceil( ( centerX + radius * Math.cos( angle ) ) );
            int yLabel = (int) Math.ceil( ( centerY + radius * Math.sin( angle ) ) );

            nodes[ i ] = new InteractionNode( x, y, xLabel, yLabel, i );

            InteractionNode n = nodes[ i ];

        }

    }

    void countEdges(){

        for( int i = 0; i < nodes.length; i++ ){

            ArrayList<InteractionNode> edges = nodes[ i ].getEdges();
            Set<InteractionNode> hashSet = new HashSet<InteractionNode>(edges);

            for( InteractionNode n : hashSet ){

                int freq = Collections.frequency( edges, n );

                if( freq > this.maxEdges ){

                    this.maxEdges = freq;

                }
            }

        }

    }

    int getMaxEdges(){

        return this.maxEdges;

    }

    void draw(){

        countEdges();

        for( InteractionNode n : nodes ){

            n.setMaxEdges( this.getMaxEdges() );
            n.drawEdges();
            n.drawLabel();

        }

        for( InteractionNode n : nodes){

            n.drawNode();

        }

    }

}

class InteractionNode extends Node{

    private int maxEdges;
    private ArrayList<InteractionNode> edges;

    InteractionNode( int x, int y, int lX, int lY, int num ){

        super( x, y, lX, lY, num );

        this.maxEdges = 1;
        this.edges = new ArrayList<InteractionNode>();

    }

    void setMaxEdges( int num ){

        this.maxEdges = num;

    }

    ArrayList<InteractionNode> getEdges(){

        return new ArrayList<InteractionNode>( this.edges );

    }

    ArrayList<InteractionNode> getDistinctEdges(){

        ArrayList<InteractionNode> resultList = new ArrayList<InteractionNode>();
        ArrayList<InteractionNode> edges = this.getEdges();
        Set<InteractionNode> hashSet = new HashSet<InteractionNode>( edges );

        for( InteractionNode n : hashSet ){

            resultList.add( n );

        }

        return resultList;

    }

    void drawEdges(){

        ArrayList<InteractionNode> distinctEdges = this.getDistinctEdges();
        ArrayList<InteractionNode> allEdges = this.getEdges();

        for( InteractionNode e : distinctEdges ){

            int countEdges = Collections.frequency( allEdges, e );
            int weight = (int) map( countEdges, 0, this.maxEdges, 1, 5 );

            color fillColor = cfg.COLOR_INTERACTION_EDGE;

            if( weight == 1 ) fillColor = color( 168, 75, 47 );     //orange
            if( weight == 2 ) fillColor = color( 82, 150, 27 );    //green
            if( weight == 3 ) fillColor = color( 113, 139, 188 );   //blue
            if( weight == 4 ) fillColor = color( 72, 62, 122 );     //purple
            if( weight == 5 ) fillColor = color( 178, 39, 48 );     //red

            fill( fillColor );
            stroke( fillColor );
            strokeWeight( weight );
            line( this.x, this.y, e.getX(), e.getY() );
            strokeWeight( 1 );

        }

    }

}
