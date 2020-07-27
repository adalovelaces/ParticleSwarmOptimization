#!/usr/bin/python

import threading
import os
import multiprocessing
import sys
from pathlib import Path
import time
import datetime
from multiprocessing import Pool
from os import path
from datetime import timedelta
import platform

global SIM
global ITER
global ANALYSIS_NH_GBEST
global ANALYSIS_NH_RING
global ANALYSIS_NH_STAR
global ANALYSIS_NH_NEUMANN
global ANALYSIS_NH_PAYOFF
global ANALYSIS_NH_PROB
global ANALYSIS_NH_PAYOFFPROB
global ANALYSIS_NH_PAYOFFSW
global ANALYSIS_NH_PROBSW
global ANALYSIS_NH_PAYOFFPROBSW
global ANALYSIS_NH_SUB
global ANALYSIS_NH_ALL
global START_TIME
global COUNT_NH

START_TIME = ""

COUNT_NH = 0

SIM = "3"
ITER = "150"

ANALYSIS_NH_TEST             = ["GBest-R2-S20"];

ANALYSIS_NH_GBEST            = ["GBest-R2-S20","GBest-R30-S20"];
ANALYSIS_NH_RING             = ["Ring-R2-S5","Ring-R30-S5"];
ANALYSIS_NH_STAR             = ["Star-R2-S5","Star-R30-S5"];
ANALYSIS_NH_NEUMANN          = ["Neumann-R2-S5","Neumann-R30-S5"];
ANALYSIS_NH_PAYOFF           = ["Payoff-R2-S5","Payoff-R30-S5"];
ANALYSIS_NH_PROB             = ["Prob-R2-S5","Prob-R30-S5"];
ANALYSIS_NH_PAYOFFPROB       = ["PayoffProb-R2-S5","PayoffProb-R30-S5"];
ANALYSIS_NH_PAYOFFSW         = ["PayoffSw-R2-S5","PayoffSw-R30-S5"];
ANALYSIS_NH_PROBSW           = ["ProbSw-R2-S5","ProbSw-R30-S5"];
ANALYSIS_NH_PAYOFFPROBSW     = ["PayoffProbSw-R2-S5","PayoffProbSw-R30-S5"];
ANALYSIS_NH_SUB              = [];
ANALYSIS_NH_ALL              = []



def run( nh, time ):

    cwd = os.getcwd()
    sketch_path = cwd + os.path.sep + "Program" + os.path.sep + "Animation"

    processing_parentfolder = str( Path( cwd ).parent )

    subfolders = os.listdir( processing_parentfolder )

    processing = ""
    for folder in subfolders:

        if "processing" in folder:
            processing = folder
            break

    if processing == ""		:

        print("\n ERROR: Processing folder not found \n")
        return

    path = get_path( nh, time )


    processing_path = processing_parentfolder + os.path.sep + processing + os.path.sep + "processing-java.exe"

    if( 'Linux' in platform.system() ):
        processing_path = processing_parentfolder + os.path.sep + processing + os.path.sep + "processing-java"


    command_part = processing_path + " --sketch=" + sketch_path + " --run argu " + path + " " + SIM + " " + ITER


    run_single( nh, command_part )


def run_single( nh, command_part ):

    command = command_part + " " + nh
    #print(command)
    if nh is not "":
        os.system(command)



def add_nh( args ):

    for arg in args[1:]:

        add_nh_single( arg )



def add_nh_single( neighborhood ):

    global ANALYSIS_NH_ALL

    if( neighborhood == "" ):
        return;

    if( neighborhood == "all" ):

        add_nh_single("gbest")
        add_nh_single("ring")
        add_nh_single("star")
        add_nh_single("neumann")
        add_nh_single("payoff")
        add_nh_single("prob")
        add_nh_single("payoffprob")
        add_nh_single("payoffsw")
        add_nh_single("probsw")
        add_nh_single("payoffprobsw")
        add_nh_single("sub")

    elif( neighborhood == "test" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_GBEST )
        create_folder( "GBest" )

    elif( neighborhood == "gbest" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_GBEST )
        create_folder( "GBest" )

    elif( neighborhood == "ring" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_RING )
        create_folder( "Ring" )

    elif( neighborhood == "star" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_STAR )
        create_folder( "Star" )

    elif( neighborhood == "neumann" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_NEUMANN )
        create_folder( "Neumann" )

    elif( neighborhood == "payoff" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_PAYOFF )
        create_folder( "Payoff" )

    elif( neighborhood == "prob" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_PROB )
        create_folder( "Prob" )

    elif( neighborhood == "payoffprob" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_PAYOFFPROB )
        create_folder( "PayoffProb" )

    elif( neighborhood == "payoffsw" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_PAYOFFSW )
        create_folder( "PayoffSw" )

    elif( neighborhood == "probsw" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_PROBSW )
        create_folder( "ProbSw" )

    elif( neighborhood == "payoffprobsw" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_PAYOFFPROBSW )
        create_folder( "PayoffProbSw" )

    elif( neighborhood == "sub" ):

        ANALYSIS_NH_ALL.extend( ANALYSIS_NH_SUB )
        create_folder( "Sub" )

def create_folder( nh ):

    global START_TIME

    pathStr = os.getcwd()
    pathStr += os.path.sep + "Simulation" + os.path.sep + START_TIME + "-" + nh

    if not path.exists( pathStr ):
        os.mkdir(pathStr)

def get_path( nh, time ):

    nhType = nh.split("-")
    nhType = nhType[ 0 ]

    path = os.getcwd()
    path += os.path.sep + "Simulation" + os.path.sep + time + "-" + nhType

    return path

def run_limited_cores( cores, sim ):

    global COUNT_NH

    end = 0
    count = 0

    start_time = datetime.datetime.now()
    while end < len(sim) :

        start = count * cores
        end = start + cores

        if end > len( sim ):

             diff = len(sim) - end
             end -= diff

        pool = multiprocessing.Pool()
        pool = multiprocessing.Pool(processes=cores)
        result_async = [ pool.apply_async(run, args = (p, START_TIME )) for p in sim[ start : end ] ]
        results = [ r.get() for r in result_async ]
        pool.close()

        print("\n")
        count += 1

        COUNT_NH += (end - start)
        print_progress( cores, COUNT_NH, len(sim), start_time )



    quit()

def run_test( cores):

    ANALYSIS_NH_TEST = ANALYSIS_NH_GBEST#,"Ring-R5-S5","Star-R5-S5","Neumann-R5-S5","Payoff-R5-S5","Prob-R5-S5","PayoffProb-R5-S5","PayoffSw-R5-S5","ProbSw-R5-S5","PayoffProbSw-R5-S5","Sub-R5-S2"]
    run_limited_cores( cores, ANALYSIS_NH_TEST )


def print_progress( cores, current, total, start_time ):

    now = datetime.datetime.now()

    seconds_elapsed = now - start_time
    seconds_per_sim = seconds_elapsed / current
    sim_left = total - current
    time_left = sim_left * seconds_per_sim

    sec_left = int(time_left.total_seconds())
    hours, rest = divmod(sec_left, 3600)
    minutes, seconds = divmod(rest, 60)

    rem_time = str(hours) + ":" + str(minutes) + ":" +  str(seconds)

    end_time = now + time_left
    end_time = end_time.strftime("%H:%M:%S")

    print("PROGRESS: " + str(current) + "/" + str(total) + " FINISHED AT: " + end_time)




if __name__ == '__main__':

    START_TIME = datetime.datetime.now().strftime("%m%d%H%M")

    output = os.getcwd()
    output += os.path.sep + "Simulation" + os.path.sep + START_TIME
    print("\nOUTPUT PATH: " + output + "\n")

    print("Start simulation")

    add_nh( sys.argv )

    cores = multiprocessing.cpu_count()

    if len(ANALYSIS_NH_ALL) < 1:

        print("\n WARNING: No neighborhood selected, run test mode \n")
        run_test( cores )
        quit()

    if len(ANALYSIS_NH_ALL) > 0 and cores < len(ANALYSIS_NH_ALL):
        print("\n WARNING: Only " + str(cores) + " cores available, run limited core mode \n")
        run_limited_cores( cores, ANALYSIS_NH_ALL )
        quit()

    if cores >= len( ANALYSIS_NH_ALL ):

        pool = multiprocessing.Pool()
        pool = multiprocessing.Pool(processes=cores)
        result_async = [pool.apply_async(run, args = (p, START_TIME )) for p in ANALYSIS_NH_ALL]
        results = [r.get() for r in result_async]

        print("Output: {}".format(results))
        pool.close()

    print("FINISHED")
    quit()
