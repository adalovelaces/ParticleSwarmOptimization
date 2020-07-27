import os
import numpy as np



def create_extract_folder( path, swarms ):

    new_path = path + "\\Reduced Data"

    if not os.path.exists( new_path ):
        os.makedirs( new_path )

    for swarm in swarms:

        swarm_path = new_path + "\\" + swarm

        if not os.path.exists(swarm_path):
            os.makedirs(swarm_path)


    return new_path

def get_reduced_iter( data, iter_list ):

    trans_data = np.transpose( data )

    reduced_iter = []

    for i in range( 0, len( trans_data[0] ) ):

        entries = []

        for iter in iter_list:

            if( iter <= len( data[ i ] ) ):
                entries.append( float( data[ i ][ iter - 1 ]) )

        reduced_iter.append( entries )

    return reduced_iter

def get_mean( data ):

    iter_mean = "["

    #for sim in range( 0, len( np.transpose( data )[0]) ):
    mean = np.mean( data, axis=0 )

    for m in range( 0, len( mean ) ):

        iter_mean += "%.3f" % mean[ m ] + ", "

    iter_mean = iter_mean[ : len( iter_mean ) - 1]
    iter_mean += "]\n"

    return iter_mean


def get_string( data ):

    string_list = []

    for sim in range( 0, len( np.transpose( data )[0]) ):

        single_sim = "["

        for iter in range( 0, len( data[0] ) ):

            single_sim += "%.3f" % data[sim][iter] + ", "

        single_sim = single_sim[ : len( single_sim) - 1 ]
        single_sim += "]\n"

        string_list.append( single_sim)

    return string_list

def extract_data( path, title, data ):

    file = open( path + title + ".txt", 'w' )

    # get all simulations but only of defined iterations
    iter_list = [ 1, 50, 75, 100, 125, 149 ]

    reduced_iter = get_reduced_iter( data, iter_list )

    file.writelines( get_string( reduced_iter ) )

    mean_iter = get_mean( reduced_iter )

    file.write( "\n" )
    file.write("MEAN:\n")
    file.write( mean_iter )

    file.close()
