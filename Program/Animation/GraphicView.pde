class GraphicView extends GraphicObject{

    protected ArrayList<GraphicObject> clickableObjectList;
    protected ArrayList<GraphicObject> allObjectList;

    GraphicView( String _name, VectorScreen _pos, VectorScreen _size ){

        super( _name, _pos, _size );
        clickableObjectList = new ArrayList<GraphicObject>();
        allObjectList = new ArrayList<GraphicObject>();

    }

    void addClickableObject( GraphicObject object ){

        this.clickableObjectList.add( object );
        addObject( object );

    }

    void addObject( GraphicObject object ){

        this.allObjectList.add( object );

    }

    void draw(){

        for( GraphicObject object : this.allObjectList ){

            if( object.name == "LabelIteration" ){

                object.draw( Integer.toString( countIter ) );

            }

            if( object.name == "LabelGBest" ){

                float value = (float) Math.round( psoGBest * 10000 ) / 10000;
                object.draw( Float.toString( value ) );

            }

            if( object.name == "LabelNeighborhood" ){

                String nh = cfg.PARTICLE_NH_TITLE;
                object.draw( nh );

            }

            if( object.name == "LabelObjectiveFunction" ){

                String of = cfg.EXPORT_VALUEFUNCTION_LIST[ cfg.SIM_VALUEFIELD_NUM ];
                object.draw(of);

            }

            if( object.name == "LabelVectorField" ){

                String vf = cfg.BUTTON_FLOWFIELD_LIST[ cfg.SIM_FLOWFIELD_NUM ];
                object.draw(vf);

            }

            if( object.name == "LabelRadius" ){

                String r = String.valueOf(cfg.PARTICLE_COMMUNICATION_RADIUS);
                object.draw(r);

            }

            if( object.name == "LabelShow" ){

                object.draw(" ");

            }

            else{

                object.draw();

            }

        }

    }

    GraphicObject getObjectUnderMouse(){

        for( GraphicObject object : this.clickableObjectList ){

            if( object.isMouseOver() ){

                return object;

            }

        }

        return null;

    }

}
