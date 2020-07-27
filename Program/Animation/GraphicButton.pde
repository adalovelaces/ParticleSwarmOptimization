class GraphicButton extends GraphicObject{

    protected String txt;
    protected float txtSize;
    protected color fillColor;
    protected color strokeColor;
    protected color txtColor;
    protected ButtonCommand command;
    protected String align;

    GraphicButton( String _name, VectorScreen _pos, VectorScreen _size, String _txt, ButtonCommand _command ){

        super( _name, _pos, _size );

        String [] exceptionsArray = new String [] { "ButtonStart", "ButtonPause", "ButtonPso", "ButtonPpso", "ButtonZpso" };
        List<String> exceptions = Arrays.asList(exceptionsArray);

        if( exceptions.contains(_name)){
            this.align = "CENTER";
        }
        else{
            this.align = "LEFT";
        }

        this.txtSize = screenSize.y / 60;
        this.txt = _txt;
        this.command = _command;
        this.fillColor = cfg.COLOR_BUTTON_STANDARD;
        this.strokeColor = cfg.COLOR_BUTTON_STANDARD;
        this.txtColor = cfg.COLOR_BUTTON_TEXT;

    }

    void execute(){

        this.command.execute();

    }

    void draw(){

        fill( this.fillColor );
        stroke( this.strokeColor );
        rect( this.screenPos.x, this.screenPos.y, this.screenSize.x, this.screenSize.y, 7 );

        PFont f = createFont( "Arial", 36, true );
        textFont( f, this.txtSize );
        fill( txtColor );
        stroke( txtColor );

        if( this.align.equals("CENTER")){

            textAlign( CENTER, CENTER );
            text( this.txt, this.screenPos.x + this.screenSize.x / 2, this.screenPos.y + this.screenSize.y / 2 );

        }
        else{

            textAlign( LEFT, CENTER );
            text( this.txt, this.screenPos.x + this.screenSize.x / 10, this.screenPos.y + this.screenSize.y / 2 );

        }


    }

}
