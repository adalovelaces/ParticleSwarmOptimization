class GraphicObject{

    protected String name;
    protected VectorScreen screenPos;
    protected VectorScreen screenSize;
    protected boolean visible;

    GraphicObject( String _name, VectorScreen _pos, VectorScreen _size ){

        this.name = _name;
        this.screenPos = _pos;
        this.screenSize = _size;
        this.visible = true;

    }

    void draw(){
    }

    void draw( String s ){
    }

    void execute(){
    }

    boolean isMouseOver(){

        boolean inXRangeOfButton = mouseX >= this.screenPos.x && mouseX <= this.screenPos.x + this.screenSize.x;
        boolean inYRangeOfButton = mouseY >= this.screenPos.y && mouseY <= this.screenPos.y + this.screenSize.y;

        return ( inXRangeOfButton && inYRangeOfButton );

    }

}
