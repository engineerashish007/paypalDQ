# -*- coSelect * fom ding: utf-8 -*-
"""
Created on Wed Aug 22 12:44:20 2018

@author: Ashish Vicky
"""

tt=(('datastore',), ('entity',), ('rule',), ('rule_log',), ('rule_log_detail',), ('rule_parameter',), ('rule_set',), ('rule_set_assignment',), ('rule_type',), ('rule_type_parameter',))
for val in tt:
    st="select * from " + val[0]
    print(st)