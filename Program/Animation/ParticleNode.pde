class Node{

    protected int x;
    protected int y;
    protected int labelX;
    protected int labelY;
    protected int num;

    Node( int x, int y, int lX, int lY, int num ){

        this.x = x;
        this.y = y;
        this.labelX = lX;
        this.labelY = lY;
        this.num = num;

    }

    int getNum(){

        return this.num;

    }

    int getX(){

        return this.x;

    }

    int getY(){

        return this.y;

    }

    void drawLabel(){

        String txt = Integer.toString( this.num + 1 );

        PFont f = createFont( "Arial", 36, true );
        float fSize = cfg.NODE_TEXT_SIZE * cfg.SCREEN_RESOLUTION / 2.5;
        textAlign(CENTER, CENTER);
        textFont( f, fSize );

        fill( 0 );
        stroke( 0 );
        text( txt, this.labelX, this.labelY );

    }

    void drawNode(){

        int xPos = this.x;//cfg.neighborHoodX + this.x;
        int yPos = this.y;//cfg.neighborHoodY + this.y;

        fill( cfg.COLOR_NEIGHBOR_NODE );
        stroke( cfg.COLOR_NEIGHBOR_NODE );
        strokeWeight( 1 );
        ellipse( xPos, yPos, cfg.NODE_RADIUS, cfg.NODE_RADIUS );


    }

}
