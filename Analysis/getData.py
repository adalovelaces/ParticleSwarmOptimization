import math as math
import numpy as np
import statistics as std
import pareto as pt

global swarm_size
swarm_size = 20
global sim_num

global sim_count
global iter_count
global swarm_count


minimum = 0.01

def set_count( sim, iter, swarm ):

    global sim_count
    global iter_count
    global swarm_count

    sim_count = sim
    iter_count = iter
    swarm_count = swarm

    print(iter_count)
    print(sim_count)


def get_iter_data( data ):

    # Get results over all iterations
    # Switch array so that data[x] represents all simulation results for iteration x
    # Transfer string to float

    iter_result = [ ]

    for i in range( 0, len( data[ 0 ] ) ):

        temp = [ ]

        for j in range( 0, len( data ) ):
            temp.append( float( data[ j ][ i ] ) )

        iter_result.append( temp )

    return iter_result

def get_iter_data_opt_single( data ):

    global minimum

    data_iter = [ ]  # gbest

    for i in range( 0, len( data ) ):

        found_iter = 151

        for j in range( 0, len( data[ 0 ] ) ):

            if (float( data[ i ][ j ] ) <= minimum):
                found_iter = j
                break

        data_iter.append( found_iter )

    return data_iter

def get_iter_data_opt_all( data1, data2 ):

    global minimum

    data1_iter = [ ]
    data2_iter = [ ]

    data1 = np.transpose(data1)
    data2 = np.transpose(data2)

    for i in range( 0, sim_count ):

        found_iter = iter_count - 1

        for j in range( 0, iter_count ):

            if ( float( data1[ i ][ j ] ) <= minimum ):
                found_iter = j
                break

        data1_iter.append( found_iter )

        if data2 is not None:

            data2_iter.append( data2[ i ][ found_iter ] )

    return data1_iter, data2_iter

def get_iter_data_opt_successful( data1, data2 ):

    global minimum

    data1_iter = [ ]
    data2_iter = [ ]

    data1 = np.transpose(data1)
    data2 = np.transpose(data2)

    for i in range( 0, sim_count ):

        found_iter = -1

        for j in range( 0, iter_count ):

            if ( float( data1[ i ][ j ] ) <= minimum ):
                found_iter = j
                break

        if found_iter != -1:
            data1_iter.append( found_iter )

        if data2 is not None and found_iter != -1:

            data2_iter.append( data2[ i ][ found_iter ] )

    return data1_iter, data2_iter


def get_iter_stdev( iter_data ):

    # Get standard deviation over all iteration results

    iter_stdev = []

    for iter in iter_data:
        iter_stdev.append( std.stdev( iter ) )

    return iter_stdev


def get_iter_stderror( iter_data ):

    iter_stdev = []

    for iter in iter_data:

        # 1. version
        #iter_stdev.append( std.stdev( iter ) / len( iter_data ) )

        # 2. version
        iter_stdev.append( std.stdev( iter ) / math.sqrt(  len( iter_data ) ) )

    return iter_stdev

def get_iter_stderror_pareto( iter_data_x, iter_data_y ):

    iter_stdev_x = std.stdev( iter_data_x )/ math.sqrt(  len( iter_data_x ) ) if len( iter_data_x ) > 1 else iter_data_x
    iter_stdev_y = std.stdev( iter_data_y )/ math.sqrt(  len( iter_data_y ) ) if len( iter_data_y ) > 1 else iter_data_y

    return iter_stdev_x, iter_stdev_y

def get_iter_mean( iter_data ):

    # Get mean value

    iter_mean = []

    for iter in iter_data:
        iter_mean.append( np.mean( iter ) )

    return iter_mean



def get_iter_mean_pareto( iter_data_x, iter_data_y ):

    iter_mean_x = np.mean( iter_data_x )
    iter_mean_y = np.mean( iter_data_y )

    return iter_mean_x, iter_mean_y

def get_sim_online( sim_data ):

    sim_online = []

    for sim_num in range( 0, sim_count ):

        sum = 0;
        sim = sim_data[ sim_num ]
        single_sim = []

        for iter_num in range( 0, iter_count ):

            sum += float( sim[ iter_num ] )
            entry = sum / (iter_num + 1 )

            single_sim.append( str( entry ) )

        sim_online.append( single_sim )

    return sim_online

def get_sim_offline( sim_data ):

    sim_offline = []

    for sim_num in range( 0, sim_count ):

        gbest_num = 0;
        gbest_value = float( sim_data[ sim_num ][ 0 ] );
        sim = sim_data[ sim_num ]
        single_sim = [ ]

        for iter_num in range( 0, iter_count ):

            value = float( sim[ iter_num ] )

            if value < gbest_value:

                gbest_num = iter_num
                gbest_value = value

            entry =( (iter_num + 1) * gbest_value ) / ( iter_num + 1 )
            single_sim.append( str( entry ) )

        sim_offline.append( single_sim )

    return sim_offline


def get_data_particle_sum_neighbor( data ):

    global swarm_size
    result_data = np.zeros( [ swarm_size, sim_count, iter_count, swarm_size ] )

    for particle in range( 0, swarm_count ):

        for sim in range( 0, sim_count ):

            for iter in range( 0, iter_count ):

                for neighbor in range ( 0, swarm_count ):

                    old_value = 0
                    if( iter > 0 ):
                        old_value = result_data[ particle ][ sim ][ iter - 1 ][ neighbor ]

                    new_value = old_value + data[particle][ sim ][ iter ][ neighbor ]
                    result_data[ particle ][ sim ][ iter ][ neighbor ] = new_value



    return result_data


def get_data_pareto_gbest_successful( root_path, data_x, data_y, type_x, type_y, nh ):

    iter_data_x = get_iter_data( data_x )
    iter_data_y = get_iter_data( data_y )

    mean_x = iter_data_x#dt_getter.get_iter_mean( iter_data_x )
    mean_y = iter_data_y#dt_getter.get_iter_mean( iter_data_y )

    mean_x2, mean_y2 = get_iter_data_opt_successful( mean_x, mean_y )

    list_nh = []

    for i in range( 0, len( mean_x2 ) ):

        p = pt.Point( mean_x2[ i ], mean_y2[ i ], type_x, type_y, nh )
        list_nh.append( p )

    return list_nh

def get_data_neighbor_mean_sum( data ):

    global swarm_size
    result_data = np.zeros([sim_count, iter_count, swarm_count])

    for sim in range(0, sim_count ):

        for iter in range(0, iter_count):

            for particle in range(0, swarm_count):

                value_list = data[particle][sim][iter]
                value_list.sort()

                for neighbor in range(0, swarm_count):

                    result_data[sim][iter][neighbor] += value_list[ neighbor ]

            for neighbor in range(0, swarm_count):
                result_data[sim][iter][neighbor] = result_data[sim][iter][neighbor] / swarm_size


    return result_data



def get_data_pareto_gbest_all( root_path, data_x, data_y, type_x, type_y, nh ):

    iter_data_x = get_iter_data( data_x )
    iter_data_y = get_iter_data( data_y )

    mean_x = iter_data_x#dt_getter.get_iter_mean( iter_data_x )
    mean_y = iter_data_y#dt_getter.get_iter_mean( iter_data_y )

    mean_x2, mean_y2 = get_iter_data_opt_all( mean_x, mean_y )

    list_nh = []

    for i in range( 0, len( mean_x2 ) ):

        p = pt.Point( mean_x2[ i ], mean_y2[ i ], type_x, type_y, nh )
        list_nh.append( p )

    return list_nh

def get_data_success( root_path, result_gbest ):

    global minimum

    last_result = []
    last_iter = len(result_gbest[0]) - 1

    count = 0
    for sim_result in result_gbest:

        gbest = float( sim_result[ last_iter ] )
        if gbest <= minimum:
            count += 1


    return (count / len(result_gbest))

def get_data_particle_mean_neighbor( data ):

    global swarm_size

    result_data = np.zeros( [ sim_count, iter_count ] )

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            for particle in range( 0, swarm_count ):

                # Get amount of neighbors
                countOnes = (data[particle][sim][iter] == 1).sum()
                result_data[ sim ][ iter ] += countOnes

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            result_data[ sim ][ iter ] = result_data[ sim ][ iter ] / swarm_size

    return result_data

def get_data_particle_min_neighbor( data ):

    global swarm_size

    result_data = np.ones( [ sim_count, iter_count ] ) * swarm_count

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            for particle in range( 0, swarm_count ):

                # Get amount of neighbors
                countOnes = (data[particle][sim][iter] == 1).sum()

                if( countOnes < result_data[ sim ][ iter ] ):

                    result_data[ sim ][ iter ] = countOnes

    return result_data

def get_data_particle_max_neighbor( data ):

    global swarm_size

    result_data = np.zeros( [ sim_count, iter_count ] )

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            for particle in range( 0, swarm_count ):

                # Get amount of neighbors
                countOnes = (data[particle][sim][iter] == 1).sum()

                if (countOnes > result_data[ sim ][ iter ]):
                    result_data[ sim ][ iter ] = countOnes

    return result_data

#def get_data_accumulation( data_raw ):

def get_data_orient( data_raw_opt, data_raw_wind ):

    data_raw = data_raw_wind

    global swarm_size

    result_data = np.zeros( [ sim_count, iter_count ] )

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            angle_list = []

            for particle in range( 0, swarm_count ):

                angle_wind = abs(float( data_raw_wind[ particle ][ sim ][ iter ] ))
                angle_list.append( angle_wind )


            median = std.median(angle_list)

            result_data[ sim ][ iter ] = median

    return result_data

    '''
    global swarm_size

    result_data = np.zeros( [ sim_count, iter_count ] )

    distance_change = np.zeros( [ swarm_count, sim_count, iter_count ] )

    for sim in range( 0, sim_count ):

        for particle in range( 0, swarm_count ):

            distance_optimum_old = float( data_raw_opt[ particle ][ sim ][ 0 ] )

            for iter in range( 0, iter_count ):

                if iter > 0:
                    distance_optimum_old = float( data_raw_opt[ particle ][ sim ][ iter-1 ] )

                distance_optimum_new = float( data_raw_opt[ particle ][ sim ][ iter ] )

                dist = distance_optimum_new - distance_optimum_old

                distance_change[ particle ][ sim ][ iter ] = dist


    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            count = 0
            c_w = 0
            c_o = 0

            for particle in range( 0, swarm_count ):

                angle_wind = abs( float( data_raw_wind[ particle ][ sim ][ iter ] ) )
                distance = float( distance_change[ particle ][ sim ][ iter ] )

                if angle_wind > 90:
                    c_w += 1
                if distance < 0.5:
                    c_o += 1

                #if( angle_wind < 45 and distance > 0.5):
                if (angle_wind <45 and distance > 0 ):
                    count += 1

            if sim == 0:
                print(c_w)
                print(c_o)
                print("\n")

            result_data[ sim ][ iter ] = count

    return result_data
    '''

def get_data_interdist( data_raw ):

    global swarm_size

    result_data = np.zeros( [ sim_count, iter_count ] )

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            result_data[ sim ][ iter ] = float( data_raw[ sim ][ iter ] )

    return result_data


def get_data_distOptCenter( data_raw ):

    return data_raw

def get_data_distOptParticle( data_raw ):

    global swarm_size

    result_data = np.zeros( [ sim_count, iter_count ] )

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            distance = 0

            for particle in range( 0, swarm_count ):

                distance += float( data_raw[ particle ][ sim ][ iter ] )


            result_data[ sim ][ iter ] = distance / swarm_count

    return result_data

def get_data_accu( data_raw ):

    accumulation_distance = 2

    global swarm_size

    result_data = np.zeros( [ sim_count, iter_count ] )

    for sim in range( 0, sim_count ):

        for iter in range( 0, iter_count ):

            count = 0

            for particle in range( 0, swarm_count ):

                distance = float(data_raw[ particle ][ sim ][ iter ])

                if( distance < accumulation_distance ):

                    count += 1

            result_data[ sim ][ iter ] = count / swarm_count

    return result_data