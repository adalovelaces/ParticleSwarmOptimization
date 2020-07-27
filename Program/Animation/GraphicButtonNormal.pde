class GraphicButtonNormal extends GraphicButton{

    GraphicButtonNormal( String _name, VectorScreen _pos, VectorScreen _size, String _txt, ButtonCommand _command  ){

        super( _name, _pos, _size, _txt, _command );

        this.screenPos.x = _pos.x - 10;
        this.screenPos.y = _pos.y;

        this.screenSize.x = _size.x - 10 * 2;
        this.screenSize.y = 40;

        this.txtSize = this.screenSize.y / 1.5;

    }

}
