#!/bin/bash

mysql -h 127.0.0.1 -P 3307 -u root -pq1w2e3r4 empresa < empresa_noticias.sql

mysql -h 127.0.0.1 -P 3307 -u root -pq1w2e3r4 empresa < empresa_usuario.sql
