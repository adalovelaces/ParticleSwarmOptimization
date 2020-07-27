class GraphicButtonSwarm extends GraphicButtonSmall{

    protected color swarmColor;
    protected float particleSize;

    GraphicButtonSwarm( String _name, VectorScreen _pos, VectorScreen _size, String _txt, color _swarmColor, ButtonCommand _command ){

        super( _name, _pos, _size, _txt, _command );

        this.swarmColor = _swarmColor;
        this.particleSize = this.screenSize.y / 1.2;

    }

    void draw(){

        super.draw();

        fill( this.swarmColor );
        stroke( 0 );
        strokeWeight( 1 );
        ellipse( this.screenPos.x + this.screenSize.x / 10, this.screenPos.y + this.screenSize.y / 2, this.particleSize, this.particleSize );

    }

}
