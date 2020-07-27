class GraphicLabel extends GraphicObject{

    color txtColor;
    String txt;
    float txtSize;

    GraphicLabel( String _name, VectorScreen _pos, VectorScreen _size, String _txt ){

        super( _name, _pos, _size );

        this.screenPos.x = _pos.x - 10;
        this.screenPos.y = _pos.y;

        this.screenSize.x = _size.x - 10 * 2;
        this.screenSize.y = 20;

        this.txt = _txt;
        this.txtColor = cfg.COLOR_LABEL_TEXT;
        this.txtSize = screenSize.y;

    }

    void draw( String changingTxt ){

        PFont f = createFont( "Arial", 35, true );
        textAlign( LEFT, CENTER );
        textFont( f, this.txtSize );

        noStroke();
        fill( this.txtColor );
        String changableTxt = this.txt + changingTxt;
        text( changableTxt, this.screenPos.x , this.screenPos.y + this.screenSize.y / 2 );

    }

}
