#!/usr/bin/env bash
export POSTGRES_USERNAME="galileo_orm"
export POSTGRES_PASSWORD="galileo_orm" 
set -ex

function galileo_orm_test () {
    cd $1;
    pub get;
    pub run test;
    cd ..
}

cd galileo_orm_generator;
pub get;
echo 1 | pub run build_runner build --delete-conflicting-outputs;
cd ..;
galileo_orm_test galileo_orm_postgres
galileo_orm_test galileo_orm_service
