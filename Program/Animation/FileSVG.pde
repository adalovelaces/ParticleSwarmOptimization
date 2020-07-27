
class FileSVG{

    private String date = "";
    private String svgPath = "";

    FileSVG(){

        this.init();

        this.createDirectory( this.svgPath );

    }

    void startExport(){

        String fileName = this.getDateString() + str( cfg.SIM_VALUEFIELD_NUM );

        beginRecord( PDF, this.svgPath + "/" + fileName + ".pdf" );

    }

    void stopExport(){

        endRecord();

    }

    void init(){

        this.date = this.getDateString();

        // Create file directory for svgs

        String rootPath = System.getProperty("user.home") + cfg.EXPORT_PATH + this.date;

        this.svgPath = rootPath;

    }

    String getDateString(){

        DateFormat dateFormat = new SimpleDateFormat("yy-MM-dd---HH-mm-ss");
        Date dateObject = new Date();
        String dateString = dateFormat.format( dateObject );

        return dateString;

    }

    void createDirectory( String path ){

        File directory = new File( path );

        boolean existing = directory.exists();
        boolean created = directory.mkdirs();

        if( !created && !existing ){

            println( "[FAILED] Creating directory: " + path );

        }

    }


}
