#!/bin/bash
#Package: toilet,fzf

INT=${1}
PROCESS=${@:2}
PS=$(ps -ely|grep -v kworker|grep -v $$|grep -v CMD|grep -v grep |awk '{print $13}')

    #Interractif Mode
    if [[ $INT == "--int" ]];then
         NAME=$(ps -ely|grep -v kworker|grep -v $$|grep -v CMD|grep -v grep |awk '{print $13}'|uniq|fzf)
         RAM=$(ps -ely|awk -v process=${NAME} '$13 ==process'|awk '{SUM += $8/1024} END {print int(SUM)}')
         echo "RAM consumes by the process $NAME : $RAM MO"
    #Default Mode 
    elif [[ $INT == "--help" ]];then
         echo "  Help menu"
         echo "--int : Interactive Mode"
         echo "--service : Show all current services"
    elif [[ $INT == "--service" ]];then
         TOTAL_PS=$(ps -ely|grep -v kworker|grep -v $$|grep -v CMD|grep -v grep |wc -l)
         TOTAL_RAM=0
        for SERVICE in $PS
          do
            RAM=$(ps -ely|awk -v process=${SERVICE} '$13 ==process'|awk '{SUM += $8/1024} END {print int(SUM)}')
            echo "RAM consumes by the process $SERVICE : $RAM MO"
            TOTAL_RAM=$(($TOTAL_RAM+$RAM))
          done
            echo "$TOTAL_PS Process"
            echo "RAM total consume : $TOTAL_RAM MO"|toilet -f term -F border
    else
    PROCESS=${@}
    if [[ -z $PROCESS ]];then
        echo "No process has been entered as a parameter"
    else
        for SERVICE in $PROCESS
          do
            RAM=$(ps -ely|awk -v process=${SERVICE} '$13 ==process'|awk '{SUM += $8/1024} END {print int(SUM)}')
            if [[ $RAM == "0" ]];then
            echo "Process $SERVICE does not exist"
            else
            echo "RAM consumes by the process $SERVICE : $RAM MO"
            fi
          done
    fi
    fi
