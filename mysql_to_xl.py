# -*- coding: utf-8 -
"""
Created on Wed Aug 22 14:40:18 2018

@author: Ashish Vicky
"""

import pymysql
from openpyxl import Workbook

db_conf=[]
#getting connection
def get_conn(db_conf):
    conn = pymysql.connect(host=str(db_conf[2]), user = str(db_conf[4]), passwd = str(db_conf[5]), db = str(db_conf[0]), port = int(db_conf[3]))
    #conn=pymysql.connect(host='localhost',user='root',passwd='root',db='DQ_METADATA',port=3306)
    return conn

#ending connection
def end_conn(conn):
    conn.close()
    
#reading data from mysql tables
def read_from_mysql(filename):
    with open(filename,"r") as f:
        read_data=f.read()
        #print(read_data)
        
        #credentials for geting connection from dbcredentials.ini file passed from mysql
        db_co=[]
        for i in read_data.splitlines():
            db_co.append(i.split(':'))
        
        for i in db_co:
            for j in range(len(i)):
                if j%2!=0:
                    db_conf.append(i[j])
        del db_co
        conn=get_conn(db_conf)        
        #cursor for executing queries and fetching result of it after establishing connection
        cursor = conn.cursor()
        #query to get all table names of the db so that later get data from all tables of the db  
        #print('---show tables---')
        sql="SHOW TABLES"
        cursor.execute(sql)
        res=cursor.fetchall()
        end_conn(conn)
        return res

#writing data into excel sheet as required    
def write_to_xl(res):
    #print(res)
    #Create workbook 
    wb=Workbook()
    #print('----------------------------------------------')
    #query to get foreign key details of all tables in db
    query1="""SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME 
            FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE REFERENCED_TABLE_SCHEMA 
            IS NOT NULL and TABLE_SCHEMA='DQ_METADATA_NEW';"""
    #cursor for executing queries and fetching result of it after establishing connection
    conn=get_conn(db_conf)
    cursor=conn.cursor()
    cursor.execute(query1)
    result1=cursor.fetchall()
    result1=list(result1)    
    #print('*******************')
    #finding unique foreign key columns list and unique non-foreign key columns list from the obtained result of above query 
    all_tables=[]
    for i in res:
        all_tables.append(i[0])
    #print('All tables:',all_tables)
    foreign_key_table=[]
    non_foreign_key_table=[]
    for r in result1:
        foreign_key_table.append(r[0])
    foreign_key_table=list(set(foreign_key_table))
    #print(foreign_key_table)
    
    for j in all_tables:
        if j not in foreign_key_table:
            non_foreign_key_table.append(j)
                
    #print('Non foreign key tables:',non_foreign_key_table)                
    #print('*******************')
    #for r in result2:
     #   print(r[0])
    #for r in result1:
     #   print(r[1])
     
    #dictionary to hold extensions to be prepended to primary and foreign key columns 
    dct_pkey={'datastore':'dst','entity':'ent','rule_assignment':'rla','rule_assignment_parameter':'rlp','rule_log':'rlg','rule_set':'rls','rule_set_assignment':'rsa','rule_type':'rlt','rule_type_parameter':'rtp'}
    dct_fkey={'DATASTORE_ID':'dst','RULE_TYPE_ID':'rlt','TARGET_ENTITY_ID':'ent','SOURCE_ENTITY_ID':'ent','RULE_ASSIGNMENT_ID':'rul','RULE_TYPE_PARAMETER_ID':'rtp','RULE_SET_ID':'rst'}
    
    
    #fetching data of all tables in the db(obtained from read_from_mysql function):
    for i in res:
        query2="SELECT * FROM "+i[0]
        conn=get_conn(db_conf)
        cursor=conn.cursor()
        cursor.execute(query2)
        result2=cursor.fetchall()
        
        #variable ws pointing to each sheet of workbook where the table is to dumped as required
        ws=wb.create_sheet(0)
        #getting the column names from each fetched table 
        column_names = [i[0] for i in cursor.description]
        
        #each worksheet is titled as name of the corresponding table 
        ws.title=i[0]
        print()
        #appending the column names first to the worksheet 
        ws.append(column_names)
        
        #foreign key columns in a list:
        foreign_key_list=[]
        foreign_key_table=[]
        for r in result1:
            foreign_key_list.append(r[1])
        
      
        #removing duplicates from foreign_key_list using set 
        uniq_foreign_key_list=set(foreign_key_list)
        uniq_foreign_key_list=list(uniq_foreign_key_list)
        
        #writing data from the table containing one or more foreign key into the pointed worksheet 
        for_key_pos=[]
        flag=0
        for k in uniq_foreign_key_list:
            pos_forkey=0
            for c in column_names:
                #checking if foreign key exists in the table by comparing unique foreign key list with column names of the pointed table and raising flag
                if k==c:
                    #adding all foreign key columns to list for_key_pos
                    for_key_pos.append(pos_forkey)
                    flag=1
                pos_forkey+=1
            
        #when foreign key exists use the above dictionary dct_pkey to add extension to primary key and dct_fkey to add extension to foreign key column(s):
        if flag==1:
            #print('++++++++++++++++++++++++++')
            #print('Table name:'+i[0])
            #print('Foreign key data:',result2)
            #print('++++++++++++++++++++++++++')
            for row in result2:
                
                pos=0;new_row=[]                
                for words in row:
                    w=str(words)
                    if pos==0:
                        words=dct_pkey[i[0]]+'_'+w.rjust(5,'0')  
                    #prepending ext to foreign key columns data in the present row                        
                    elif pos in for_key_pos:
                        if words is None:
                            #when no data is their in corresponding cell of mysql
                            words=dct_fkey[column_names[pos]]+'_'+'00000'
                        else:
                            words=dct_fkey[column_names[pos]]+'_'+w.rjust(5,'0')
                            #print(words,sep="|")
                    else:
                        pass
                        #print(words,sep="|")
                    new_row.append(words)
                    pos=pos+1
                    
                ws.append(new_row)
                print('\n')
        #writing data from the table not containing any foreign key into the pointed worksheet    
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
                    #use the above dictionary dct_pkey to add extension to primary key
                    if pos==0:
                        words=dct_pkey[i[0]]+'_'+w.rjust(5,'0')
                        #print(words)                           
                    new_row.append(words)
                    pos=pos+1
                ws.append(new_row)
    #naming the workbook and file position where it is to be placed        
    workbook_name = "test_workbook_8"
    filepath='C:/Users/Ashish Vicky/Documents/POCs/Platform/code_ashish/resultsheet/'+workbook_name
    #saving the workbook
    wb.save(filepath+".xlsx")
        
    end_conn(conn)
        #conn.close()
    
if __name__=='__main__':
    filename="C:/Users/Ashish Vicky/Documents/POCs/Platform/code_ashish/dbcredentials.ini"
    res=read_from_mysql(filename)
    write_to_xl(res)
