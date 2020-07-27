class GraphicButtonVerySmall extends GraphicButton{

    GraphicButtonVerySmall( String _name, VectorScreen _pos, VectorScreen _size, String _txt, ButtonCommand _command ){

        super( _name, _pos, _size, _txt, _command );

        this.screenPos.x = _pos.x - 10;
        this.screenPos.y = _pos.y;

        this.screenSize.x = _size.x / 2 - 10 * 2;
        this.screenSize.y = 20;

    }

}
