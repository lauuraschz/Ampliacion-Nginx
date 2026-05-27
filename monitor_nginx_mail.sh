#!/bin/bash

DESTINO="sanchezurdalaura@gmail.com"

tail -n 0 -F /var/log/nginx/access.log | while read line
do
    if echo "$line" | grep -q "curl/8"
    then
        IP=$(echo $line | awk '{print $1}')

        if [ "$IP" = "127.0.0.1" ]
        then
            PETICION=$(echo $line | awk -F\" '{print $2}')

            METHOD=$(echo $PETICION | awk '{print $1}')

            URL=$(echo $PETICION | awk '{print $2}')

            FECHA=$(date)

            MENSAJE="Evento detectado en Nginx

Fecha: $FECHA
Cliente: $IP
Método HTTP: $METHOD
Recurso solicitado: $URL"

            echo "$MENSAJE" | mail -s "Evento Nginx detectado" $DESTINO
        fi
    fi
done
