import datetime

time_start = None

def start( all_setting ):

    global time_start

    time_start = datetime.datetime.now()


def get_elapsed_time():

    return datetime.datetime.now() - time_start

def show_remaining_time( setting, all_setting ):

    elapsed_time = get_elapsed_time()
    remaining_time = get_remaining_time( setting, all_setting )

    time_string_elapsed = str(elapsed_time).split(".")[0]
    time_string_remaining = str(remaining_time).split(".")[0]

    print( "ELAPSED TIME: " + time_string_elapsed + " REMAINING TIME: " + time_string_remaining )

def get_remaining_time( current_setting, all_setting ):

    elapsed_time = get_elapsed_time()

    vf = current_setting[ 0 ]
    of = current_setting[ 1 ]
    sw = current_setting[ 2 ]

    finished_vf = all_setting[0].index( vf )
    finished_of = all_setting[1].index( of )
    finished_sw = all_setting[2].index( sw )

    max_vf = len( all_setting[ 0 ] )
    max_of = len( all_setting[ 1 ] )
    max_sw = len( all_setting[ 2 ] )

    max_all = max_vf * max_of * max_sw

    sim_finished = finished_sw + 1
    sim_finished += finished_of * max_sw
    sim_finished += finished_vf * max_sw * max_of

    percentage = sim_finished / max_all
    predicted_time = get_time_prediction( sim_finished, max_all )

    return predicted_time


def get_time_prediction( sim_finished, sim_all ):

    global time_start

    time_now = datetime.datetime.now()
    time_elapsed = get_elapsed_time()

    time_per_sim = time_elapsed / sim_finished

    time_remaining = time_per_sim * ( sim_all - sim_finished )

    return time_remaining