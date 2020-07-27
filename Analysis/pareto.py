import numpy as np
import plotDisplay as pltDisp

class Point:

   def __init__(self, x, y, type_x, type_y, nh):
        self.x = x
        self.y = y
        self.type_x = type_x
        self.type_y = type_y
        self.nh = nh

   def toString( self ):

       return '(' + str( self.x ) + ' ' + str( self.y ) + ')'

   def get_nh( self ):

        return self.nh

   def get_x( self ):

        return self.x

   def get_y( self ):

        return self.y

   def get_type_x( self ):

       return self.type_x

   def get_type_y( self ):

       return self.type_y

class Pareto:

    list = [None] * 1000
    success = np.zeros(1000)

    list_all_gbest = []
    list_all_basic = []
    list_all_new = []
    list_all_switch = []
    list_all_sub = []

    def get_list( self, nh ):

        num = int(nh[2:])
        return self.list[ num ]


    def add( self, list, success_rate, nh ):

        num = int(nh[2:])

        self.list[ num ] = list
        self.success[ num ] = success_rate

        group = pltDisp.get_group( nh )

        if (group == 'GBEST'):
            self.list_all_gbest = self.list_all_gbest + list

        if (group == 'BASIC'):
            self.list_all_basic = self.list_all_basic + list

        if (group == 'NEW'):
            self.list_all_new = self.list_all_new + list

        if (group == 'SWITCH'):
            self.list_all_switch = self.list_all_switch + list

        if (group == 'SUBWARM'):
            self.list_all_sub = self.list_all_sub + list


    def print_list( self, list ):

        print_string = "["

        for point in list:

            print_string += point.toString() + ', '

        print_string += ']'
        print( print_string )

    def get_success_rate( self, nh ):

        num = int(nh[2:])
        return self.success[ num ]

    def get_values_nh( self, nh ):

        list_pareto_x = []
        list_pareto_y = []

        list_nh = self.get_list( nh )

        for point in list_nh:

            list_pareto_x.append( point.x )
            list_pareto_y.append( point.y)

        return list_pareto_x, list_pareto_y


    #def get_pareto_all_of_list( self, list ):
    def get_values_of_list( self, list ):

        list_pareto_x = [ ]
        list_pareto_y = [ ]

        for point in list:
            list_pareto_x.append( point.x )
            list_pareto_y.append( point.y )

        return list_pareto_x, list_pareto_y


    #def get_pareto_optimal_points_all( self ):
    def get_optimal_points_all( self, nh ):

        result_list = []

        group = pltDisp.get_group( nh )

        if( group == 'GBEST' ):
            result_list = self.calculate_optimal(self.list_all_gbest)

        if( group == 'BASIC' ):
            result_list = self.calculate_optimal(self.list_all_basic)

        if (group == 'NEW'):
            result_list = self.calculate_optimal(self.list_all_new)

        if (group == 'SWITCH'):
            result_list = self.calculate_optimal(self.list_all_switch)

        if (group == 'SUBSWARM'):
            result_list = self.calculate_optimal(self.list_all_sub)


        return result_list

    #def get_pareto_optimal_of_list( self, list_in ):
    def get_optimal_points_of_list( self, list_in ):

        result_list = self.calculate_optimal( list_in )
        return result_list


    def calculate_optimal( self, list_in ):

        if len( list_in ) == 0:
            return []

        type1 = list_in[0].get_type_x()
        type2 = list_in[0].get_type_y()

        rev = False if type1 is 'min' else True

        list_sort = sorted( list_in, key=lambda point: point.x, reverse=rev )

        minimum = type2 is 'min'
        maximum = type2 is 'max'

        index_list = [ ]

        best_value = 10000000 if minimum else 0

        i = 0
        while i < len( list_sort ):

            if( minimum and list_sort[i].y < best_value ) or ( maximum and list_sort[i].y > best_value ):

                if( i < len(list_sort) - 2 and not list_sort[i].x == list_sort[i+1].x ):

                    best_value = list_sort[ i ].y
                    index_list.append( i )

                else:

                    best_same_value = best_value
                    best_same_index = i
                    j = i

                    while( j < len(list_sort) - 1 and list_sort[ j ].x == list_sort[ i ].x ):

                        if( minimum and list_sort[ j ].y < best_same_value ) or ( maximum and list_sort[ j ].y > best_same_value ):
                            best_same_value = list_sort[ j ].y
                            best_same_index = j

                        j += 1

                    index_list.append( best_same_index )
                    best_value = best_same_value
            i += 1

        result_list = []

        for i in index_list:
            result_list.append( list_sort[ i ] )

        return result_list

