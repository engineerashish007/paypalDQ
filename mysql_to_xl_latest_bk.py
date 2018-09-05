# -*- coding: utf-8 -
"""
Created on Wed Aug 22 14:40:18 2018

@author: Ashish Vicky
"""

import pymysql
from openpyxl import Workbook

db_conf=[]
def get_conn(db_conf):
    conn = pymysql.connect(host=str(db_conf[2]), user = str(db_conf[4]), passwd = str(db_conf[5]), db = str(db_conf[0]), port = int(db_conf[3]))
    #conn=pymysql.connect(host='localhost',user='root',passwd='root',db='DQ_METADATA',port=3306)
    return conn

def end_conn(conn):
    conn.close()
    
def read_from_mysql(filename):
    with open(filename,"r") as f:
        read_data=f.read()
        #print(read_data)
        db_co=[]
        for i in read_data.splitlines():
            db_co.append(i.split(':'))
        
        for i in db_co:
            for j in range(len(i)):
                if j%2!=0:
                    db_conf.append(i[j])
        del db_co
        conn=get_conn(db_conf)
        #conn = pymysql.connect(host=str(db_conf[2]), user = str(db_conf[4]), passwd = str(db_conf[5]), db = str(db_conf[0]), port = int(db_conf[3]))
        #conn=pymysql.connect(host='localhost',user='root',passwd='root',db='DQ_METADATA',port=3306)
        cursor = conn.cursor()
        
        print('---show tables---')
        sql="SHOW TABLES"
        cursor.execute(sql)
        res=cursor.fetchall()
        end_conn(conn)
        return res
    
def write_to_xl(res):
    print(res)
    #Create workbook 
    wb=Workbook()
    print('----------------------------------------------')
    query1="""SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME 
            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_SCHEMA 
            IS NOT NULL and TABLE_SCHEMA='DQ_METADATA_NEW';"""
    
    conn=get_conn(db_conf)
    cursor=conn.cursor()
    cursor.execute(query1)
    result1=cursor.fetchall()
    result1=list(result1)
    
    print('*******************')
    all_tables=[]
    for i in res:
        all_tables.append(i[0])
    print('All tables:',all_tables)
    foreign_key_table=[]
    non_foreign_key_table=[]
    for r in result1:
        foreign_key_table.append(r[0])
    foreign_key_table=list(set(foreign_key_table))
    print(foreign_key_table)
    
    for j in all_tables:
        if j not in foreign_key_table:
            non_foreign_key_table.append(j)
                
    print('Non foreign key tables:',non_foreign_key_table)
                
    print('*******************')
    #for r in result2:
     #   print(r[0])
    #for r in result1:
     #   print(r[1])
    dct_pkey={'datastore':'dst','entity':'ent','rule_type':'rlt','rule_type_parameter':'rtp','rule':'rl','rule_parameter':'rlp','rule_set':'rls','rule_set_assignment':'rsa'}
    dct_fkey={'DATASTORE_ID':'dst','RULE_TYPE_ID':'rlt','TARGET_ENTITY_ID':'ent','SOURCE_ENTITY_ID':'ent','RULE_ASSIGNMENT_ID':'rul','RULE_TYPE_PARAMETER_ID':'rtp','RULE_SET_ID':'rst'}
    
    for i in res:
        query2="SELECT * FROM "+i[0]
        conn=get_conn(db_conf)
        cursor=conn.cursor()
        cursor.execute(query2)
        result2=cursor.fetchall()
        print('-------------------')
        print(result2)
        print(type(result2))
        print('-----------------')
        ws=wb.create_sheet(0)
        #num_fields = len(cursor.description)
        column_names = [i[0] for i in cursor.description]
        #print(column_names)
        #column_names=i[0].row
        ws.title=i[0]
        print()
        ws.append(column_names)
    
        foreign_key_list=[]
        foreign_key_table=[]
        for r in result1:
            foreign_key_list.append(r[1])
        #print(rlist)
        
        
            
        print(foreign_key_list)
        
        """
        foreign key list contains duplicates as:
        'entity', 'DATASTORE_ID', 'entity_ibfk_1'
        'rule_assignment', 'RULE_TYPE_ID', 'rule_assignment_ibfk_1'
        'rule_assignment', 'TARGET_ENTITY_ID', 'rule_assignment_ibfk_2'
        'rule_assignment', 'SOURCE_ENTITY_ID', 'rule_assignment_ibfk_3'
        'rule_assignment_parameter', 'RULE_ASSIGNMENT_ID', 'rule_assignment_parameter_ibfk_1'
        'rule_assignment_parameter', 'RULE_TYPE_PARAMETER_ID', 'rule_assignment_parameter_ibfk_2'
        'rule_log', 'RULE_ASSIGNMENT_ID', 'fk_RULE_LOG_RULE1'
        'rule_set_assignment', 'RULE_SET_ID', 'rule_set_assignment_ibfk_1'
        'rule_set_assignment', 'RULE_ASSIGNMENT_ID', 'rule_set_assignment_ibfk_2'
        'rule_type_parameter', 'RULE_TYPE_ID', 'rule_type_parameter_ibfk_1'
        """
        #removing duplicates from foreign_key_list using set 
        
        
        uniq_foreign_key_list=set(foreign_key_list)
        uniq_foreign_key_list=list(uniq_foreign_key_list)
        for k in uniq_foreign_key_list:
            flag=0;pos_forkey=0
            for c in column_names:
                if k==c:
                    flag=1
                    break
                
                pos_forkey+=1
                
            if flag==1:
                print('++++++++++++++++++++++++++')
                print('Table name:'+i[0])
                print('Foreign key data:',result2)
                print('++++++++++++++++++++++++++')
                for row in result2:
                    pos=0;new_row=[]                
                    for words in row:
                        w=str(words)
                        
                        if pos==0:
                            words=dct_pkey[i[0]]+'_'+w.rjust(5,'0')
                            
                            print(words)
                        elif pos==pos_forkey:   
                            words=dct_fkey[k]+'_'+w.rjust(5,'0')
                            print(words,sep="|")
                        else:
                            print(words,sep="|")
                        new_row.append(words)
                        pos=pos+1
                    
                    ws.append(new_row)
                print('\n')
            
        if i[0] in non_foreign_key_table:
            query3="SELECT * FROM "+i[0]  
            cursor=conn.cursor()
            cursor.execute(query3)
            result3=cursor.fetchall()
            for row in result3:
                row=list(row)
                new_row=[];pos=0
                for words in row:
                    w=str(words)
                    if pos==0:
                        words=dct_pkey[i[0]]+'_'+w.rjust(5,'0')
                        print(words)
                            
                    new_row.append(words)
                    pos=pos+1
                ws.append(new_row)
            
    workbook_name = "test_workbook_50"
    filepath='C:/Users/Ashish Vicky/Documents/POCs/Platform/code_ashish/testsheet/'+workbook_name
    wb.save(filepath+".xlsx")
        
    end_conn(conn)
        #conn.close()
    
if __name__=='__main__':
    filename="C:/Users/Ashish Vicky/Documents/POCs/Platform/varun KT code/dbcredentials.ini"
    res=read_from_mysql(filename)
    write_to_xl(res)