
import re

marker_default = '.'
marker_nh1 = 'o'
marker_nh2 = 'v'
marker_nh3 = '^'
marker_nh4 = '<'
marker_nh5 = '>'
marker_nh6 = 's'
marker_nh7 = 'p'
marker_nh8 = 'P'
marker_nh9 = '*'
marker_nh10 = 'X'
marker_nh11 = 'D'
marker_nh12 = 'd'

linestyle_default   = (0, ())
linestyle_nh1       = (0, (1, 10))
linestyle_nh2       = (0, (1, 5))
linestyle_nh3       = (0, (1, 1))
linestyle_nh4       = (0, (5, 10))
linestyle_nh5       = (0, (5, 5))
linestyle_nh6       = (0, (5, 1))
linestyle_nh7       = (0, (3, 10, 1, 10))
linestyle_nh8       = (0, (3, 5, 1, 5))
linestyle_nh9       = (0, (3, 1, 1, 1))
linestyle_nh10      = (0, (3, 10, 1, 10, 1, 10))
linestyle_nh11      = (0, (3, 5, 1, 5, 1, 5))
linestyle_nh12      = (0, (3, 1, 1, 1, 1, 1))

color_default       = 'black'
color_nh1           = '#de998c'
color_nh2           = '#ff6b4f'
color_nh3           = '#e8b851'
color_nh4           = '#990c0c'
color_nh5           = '#3bb886'
color_nh6           = '#327c9c'
color_nh7           = '#644e87'
color_nh8           = '#cc6cb4'
color_nh9           = '#13663b'
color_nh10          = '#70cfcb'
color_nh11          = '#09494f'
color_nh12          = '#3297a8'
color_nh13          = '#217c85'
color_nh14          = '#09494f'
color_nh15          = '#de998c'

global NH_TYPES
global NH_TITLES
global NH_EXT_GBEST
global NH_EXT_SUB
global NH_EXT_ALL
global NH_TYPES_GBEST
global NH_TYPES_BASIC
global NH_TYPES_NEW
global NH_TYPES_SWITCH
global NH_TYPES_SUB

NH_TYPES = ['GBEST', 'BASIC', 'NEW', 'SWITCH', 'SUBSWARM']

NH_TITLES = ['GBest', 'Ring', 'Star', 'Neumann', 'Payoff', 'Prob', 'PayoffProb', 'PayoffSw', 'ProbSw', 'PayoffProbSw']

NH_EXT_GBEST = [ 'S5', 'S10', 'S20' ]#'R5S5', 'R5S10', 'R5S20', 'R10S5', 'R10S10', 'R10S20', 'R20S5', 'R20S10', 'R20S20' ]
NH_EXT_ALL = [ 'R2', 'R5', 'R30' ]#, 'R5', 'R10', 'R20', 'R5', 'R10', 'R20' ]
NH_EXT_SUB = ['S2', 'S5', 'S10' ]#, 'R10S5', 'R10S10', 'R20S2', 'R20S5', 'R20S10']

NH_RADIUS = [ 'R2', 'R5', 'R30' ]

NH_TYPES_GBEST = ['NH11', 'NH12', 'NH13', 'NH14', 'NH15', 'NH16', 'NH17', 'NH18', 'NH19']
NH_TYPES_BASIC = ['NH21', 'NH24', 'NH27', 'NH31', 'NH34', 'NH37', 'NH41', 'NH44', 'NH47']
NH_TYPES_NEW = ['NH51', 'NH54', 'NH57', 'NH61', 'NH64', 'NH67', 'NH71', 'NH74', 'NH77']
NH_TYPES_SWITCH = ['NH81', 'NH84', 'NH87', 'NH91', 'NH94', 'NH97', 'NH101', 'NH104', 'NH107']
NH_TYPES_SUB = ['NH111', 'NH112', 'NH113', 'NH114', 'NH115', 'NH116', 'NH117', 'NH118', 'NH119']


def init( list ):

    global NH_TITLES

    #NH_TITLES = list

def get_axes( nh ):

    return nh[ 2: ]

def get_title_vf( vf ):

    num = vf[ 2: ]

    return {
        '1': "Cross",
        '2': "Rotation",
        '3': "Sheared",
        '4': "Fall",
        '5': "Tornado",
        '6': "Bi-Directional",
        '7': "Random",
        '8': "Multi-Rotation",
        '9': "Vortex",
        '10': "Real1",
        '11': "Real2",
        '12': "Real3"
    }.get( num, "VF " + vf[2:])

def get_title_of( of ):

    num = of[ 2: ]

    return {
        '1': "Sphere",
        '2': "Rosenbrock",
        '3': "Ackley"
    }.get( num, "Unknown Function" )

def get_types():

    return NH_TYPES

def get_nh_titles(nh):

    global NH_TITLES

    numbers = re.findall("\d+", nh)

    num1 = int(int(numbers[0]) / 10) - 1
    num2 = int(int(numbers[0]) % 10)

    title = NH_TITLES[num1]

    return title


def get_first_num( nh_string ):

    numbers = re.findall( "\d+", nh_string )

    nh_num = int( int( numbers[ 0 ] ) / 10 ) - 1

    return nh_num


def get_second_num( nh_string ):

    numbers = re.findall( "\d+", nh_string )

    nh_num = int( int( numbers[ 0 ] ) % 10 )

    return nh_num

def get_nh_num( nh_string ):

    numbers = re.findall( "\d+", nh_string )

    nh_num = int( int( numbers[ 0 ] ) / 10 ) - 1

    return nh_num

def get_radius( nh ):

    numbers = re.findall( "\d+", nh )

    num1 = int( int( numbers[ 0 ] ) / 10 ) - 1
    num2 = int( int( numbers[ 0 ] ) % 10 )

    gbest_r2 = num1 == 0 and num2 == 6
    gbest_r30 = num1 == 0 and num2 == 9
    other_r2 = num1 is not 0 and num2 == 4
    other_r30 = num1 is not 0 and num2 == 7


    if( gbest_r2 or other_r2 ):
        return 2
    if( gbest_r30 or other_r30 ):
        return 30

    return 0

def get_name( nh ):

    numbers = re.findall( "\d+", nh )

    num1 = int( int( numbers[ 0 ] ) / 10 ) - 1

    name = NH_TITLES[ num1 ]

    return name

def get_label( swarm ):

    return swarm


def get_marker( swarm ):

    if (swarm == 'PPSO-R2' or swarm == 'R2'):
        num = 1
    if (swarm == 'ZPSO-R2'):
        num = 2
    if (swarm == 'R22'):
        num = 3
    if (swarm == 'PPSO-R30' or swarm == 'R30'):
        num = 5
    if (swarm == 'ZPSO-R30'):
        num = 6
    if (swarm == 'R302'):
        num = 7

    return {
        1: marker_nh1,
        2: marker_nh2,
        3: marker_nh3,
        4: marker_nh4,
        5: marker_nh5,
        6: marker_nh6,
        7: marker_nh7,
        8: marker_nh8,
        9: marker_nh9,
        10: marker_nh10,
        11: marker_nh11,
        12: marker_nh12
    }.get( num, marker_default )


def get_linestyle( swarm ):

    if (swarm == 'PPSO-R2' or swarm == 'R2'):
        num = 1
    if (swarm == 'ZPSO-R2'):
        num = 2
    if (swarm == 'R22'):
        num = 3
    if (swarm == 'PPSO-R30' or swarm == 'R30'):
        num = 5
    if (swarm == 'ZPSO-R30'):
        num = 6
    if (swarm == 'R302'):
        num = 7

    return {
        1: linestyle_nh1,
        2: linestyle_nh2,
        3: linestyle_nh3,
        4: linestyle_nh4,
        5: linestyle_nh5,
        6: linestyle_nh6,
        7: linestyle_nh7,
        8: linestyle_nh8,
        9: linestyle_nh9,
        10: linestyle_nh10,
        11: linestyle_nh11,
        12: linestyle_nh12
    }.get( num, linestyle_default )


def get_color( swarm ):

    blue_light = '#496cbf'
    blue_dark = '#24365e'
    red_light = '#bd3c51'
    red_dark = '#851124'
    green_light = '#cf9d1f'
    green_dark = '#d95b0d'

    if (swarm == 'ZPSO-R2'):
        return blue_light
    if (swarm == 'ZPSO-R30'):
        return blue_dark

    if (swarm == 'PPSO-R2'):
        return red_light
    if (swarm == 'PPSO-R30'):
        return red_dark

    if (swarm == 'R2'):
        return blue_dark
    if (swarm == 'R30'):
        return red_dark

    if (swarm == 'R22'):
        return green_light
    if (swarm == 'R302'):
        return green_dark

    num = 1

    return {
        1 : color_nh1,
        2 : color_nh2,
        3 : color_nh3,
        4 : color_nh4,
        5 : color_nh5,
        6 : color_nh6,
        7 : color_nh7,
        8 : color_nh8,
        9 : color_nh9,
        10: color_nh10,
        11: color_nh11,
        12: color_nh12,
        13: color_nh13
    }.get( num, color_default )
