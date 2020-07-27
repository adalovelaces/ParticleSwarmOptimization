class FileParser{

    FileParser(){

    }

    ArrayList<String> read( String path ){

        ArrayList<String> readLines = new ArrayList<String>();

        File f = new File( path );
        if( ! f.exists() ){
            return readLines;
        }

        BufferedReader reader = createReader( path );
        String line = null;

        try {

            while ((line = reader.readLine()) != null) {
                String[] pieces = split(line, TAB);
                readLines.add(pieces[0]);
            }
            reader.close();

        } catch (IOException e) {

            e.printStackTrace();

        }
        return readLines;
    }

    void write( String text, String path ){

        // Get lines which are already written
        ArrayList<String> readLines = this.read( path);

        PrintWriter output = createWriter( path );

        // Rewrite already existing lines
        for( String line : readLines ){

            output.println(line);

        }

        output.println( text );

        output.flush();
        output.close();

    }

}
