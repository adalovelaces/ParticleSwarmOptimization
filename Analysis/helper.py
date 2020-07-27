from glob import glob
from pathlib import Path
import os
import re
import random


VF = []
OF = []
NH = []
sim = 0
path_merge_folder = ""


def get_line_entries( line ):

    subString = line[ line.find( "[" ) + 1:line.find( "]" ) ]

    entries = subString.split( ',' )

    return entries

def get_all_simulations( path ):

    file = open( path, "r+" )
    all_lines = file.readlines()
    file.close()

    return all_lines

def get_simulations( path ):

    file = open( path, "r+" )
    all_lines = file.readlines()
    file.close()

    return len( all_lines )


def get_iterations( path ):

    file = open( path, "r+" )
    all_lines = file.readlines()
    file.close()

    return len( get_line_entries( all_lines[ 0 ] ) )


def get_folder_in_path( file_path ):

    folders = [ ]

    all_folders = glob( file_path + "\\*" )

    for path in all_folders:

        folder_name = os.path.basename( path )
        folders.append( folder_name )

    return folders


def get_files_in_path( file_path ):

    files = [ ]
    
    all_files = glob( file_path + "\\*" )

    for path in all_files:

        file_name = os.path.basename( path )
        file_setting = file_name.split('_')

        if( len(file_setting) > 1 ):

            global VF
            global OF
            global NH

            file_setting = file_setting[ 1 ]

            numbers = []

            for n in re.findall( r'-?\d+\.?\d*', file_setting):

                numbers.append( n )


            file_vf = int( numbers[ 0 ] )
            file_of = int( numbers[ 1 ] )
            file_nh = int( numbers[ 2 ] )

            # Only append the wanted files (defined at top)
            if( file_vf in VF ) and ( file_of in OF ) and ( file_nh in NH):

                files.append( file_name )


        else:
            files.append( file_name )

    return files

def get_line_numbers( file_path ):

    if not os.path.isfile( file_path ):
        return 0

    f = open( file_path, 'r' )
    line_num = 0

    for line in f.readlines():
        line_num += 1

    return line_num

def check_missing_simulations( path, swarm, limit ):

    global VF
    global OF
    global NH
    global path_merge_folder

    root = path + "\\" + swarm

    for vf in VF:

        for of in OF:

            for nh in NH:

                title = swarm + "_VF" + str(vf) + "OF" + str(of) + "NH" + str(nh)
                path = root + "\\" + title + "_GBest.txt"

                if not os.path.exists( path ):

                    print( swarm + " VF" + str(vf) + " OF" + str(of) + "NH" + str(nh) + " missing " + str( limit ) + " simulations ")

                else:

                    global sim
                    count = get_simulations(path)
                    missing = limit - count

                    if missing > 0:

                        print( swarm + " VF" + str(vf) + " OF" + str(of) + " NH" + str( nh ) + " missing " + str( missing ) + " simulations" )

                    if missing < 0:

                        print( swarm + " VF" + str(vf) + " OF" + str(of) + " NH" + str( nh ) + " " + str( missing ) + " too much simulations" )

                    all_simulations = get_all_simulations(path)
                    limit_iter = 150

                    for simulation in all_simulations:

                        count = len( get_line_entries( simulation ) )

                        if count < limit_iter:

                            missing = limit_iter - count
                            print("NH" + str(nh) + " missing " + str(missing) + " iterations")



def merge_files( swarm, limit ):

    global path_merge_folder

    root_path = str( Path.home() ) + path_merge_folder + "\\Mergefolder " + swarm
    import_path = root_path + "\\Import"
    export_path = root_path + "\\Export"

    if not os.path.exists( export_path ):
        os.makedirs( export_path )

    # Clear export folder
    for root, dirs, files in os.walk( export_path ):
        for file in files:
            os.remove( os.path.join( root, file ) )

    print( import_path )

    all_folder = get_folder_in_path( import_path )


    for folder in all_folder:

        file_path = import_path + "\\" + folder + "\\Data\\" + swarm

        all_files = get_files_in_path( file_path )
        print( file_path + " " + str(len(all_files)) )

        for file in all_files:

            in_path = file_path + "\\" + file
            out_path = export_path + "\\Data\\" + swarm + "\\" + file

            with open( in_path ) as f:

                with open( out_path, "a" ) as f1:

                    #count = get_simulations( out_path )
                    #if (count > limit):
                    #    print( "1 " + str( count ) )

                    #if( count >= limit ):
                     #   break

                    for line in f:

                        # Prevent writing to many lines
                        count = get_simulations( out_path )

                        if count >= limit:
                            break

                        if( count > limit ):
                            print( count )

                        f1.write( line )

            if not os.path.exists( out_path ):
                print("NOT EXIST "+ out_path)
            #print("... working")

    print("FINISHED MERGING FOLDERS")


def rename_vf():

    path = "C:\\Users\\doree\\Desktop\\NH1-4\\PPSO\\"

    files = [ ]
    for name in os.listdir( path ):
        if os.path.isfile( os.path.join( path, name ) ):

            numbers = []

            for n in re.findall( r'-?\d+\.?\d*', name):

                numbers.append( n )

            file_setting = name.split( '_', 2)

            file_vf = int( numbers[ 0 ] )
            file_of = int( numbers[ 1 ] )
            file_nh = int( numbers[ 2 ] )

            if( file_vf == 13 ):

                newName = file_setting[ 0 ] + "_VF12" + "OF" + numbers[1] + "NH" + numbers[2] + "_" + file_setting[ 2 ]

                src = path + name
                dst = path + newName

                print( src )
                print( dst )
                os.rename( src, dst )



def create_random_initialisation():

    root_path = str( Path.home() ) + "\\Desktop\\Initialisation"

    if not os.path.exists( root_path ):
        os.makedirs( root_path )

    path_x = root_path + "\\init_x.txt"
    path_y = root_path + "\\init_y.txt"

    f_x = open( path_x, "w+" )
    f_y = open( path_y, "w+" )

    for i in range( 0, 31 ):

        for j in range ( 0, 20 ):

            x = random.uniform(-14, 14)
            y = random.uniform(-14, 14)

            f_x.write( str( x ) + "," )
            f_y.write( str( y ) + "," )

        f_x.write( "\n" )
        f_y.write( "\n" )

    f_x.close()
    f_y.close()


print("START MERGING FOLDERS")

sim = 31
path_merge_folder = "\\Desktop\\MergeFolder"
path = "C:\\Users\\doree\\Desktop\\MergeFolder\\MergeFolderzPSO\\Import\\MERGE"#"\\Desktop\\MergeFolder"
path = "C:\\Users\\doree\\Desktop\\MergeFolder\\MergeFolder ZPSO\\Import\\MERGE\\Data"
#C:\Users\doree\Desktop\ALL\Data


#1, 4, 9 as speficication
VF = [ 1,3,4,6,10,12] #,10,12 ]
OF = [ 1,2,3]
NH = [16,24,34,54,64,74,84,94,104,114, 115, 116]
#missing 44
#[11,12,13,14,15,16,17,18,21,24,27,31,34,37,41,44,47,51,54,57,61,64,67,71,74,77,81,84,87,91,94,97,101,104,107,,111,114,117,121,124,127,131,134,137 ]#11,12,13,14,15,16,17,18,19,21,24,27,31,34,37,41,44,47,51,54,57,61,64,67,71,74,77,81,84,87,91,94,97,101,104,107 ]


#merge_files( "ZPSO", sim )
#merge_files( "PPSO", sim )

check_missing_simulations( path, "ZPSO", sim )
check_missing_simulations( path, "PPSO", sim )

#rename_vf()


#create_random_initialisation()