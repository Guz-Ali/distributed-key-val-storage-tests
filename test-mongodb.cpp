#include <chrono>
#include <string>
#include <fstream>
#include <iostream>
#include <unordered_map>
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>
#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/array.hpp>
#include <bsoncxx/json.hpp>
#include <mongocxx/uri.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/client.hpp>
#include <mongocxx/stdx.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>

using bsoncxx::builder::stream::finalize;
using bsoncxx::builder::stream::close_document;
using bsoncxx::builder::stream::open_document;
using bsoncxx::builder::stream::close_array;
using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::open_array;


int main(){

	std::ifstream keys("keys.txt");
	std::ifstream vals("values.txt");
	std::unordered_map<std::string, std::string> pairs;
	int count = 0;

	if(keys == 0 || vals == 0){
		std::cout << "Couldn't open files: keys.txt || values.txt" << std:endl;
		return 0;
	}

	// read from the data files: keys.txt and values.txt
	std::string key, val;
	while (std::getline(keys, key) && std::getline(vals, val)){
		pairs[key] = val;
		count ++;
	}


	// initiate instance
	mongocxx::instance instance{}; 
	// start client on the ip with mongocxx
	mongocxx::client client{mongocxx::uri{}};
	// create database and collection
	mongocxx::database db = client["mongodb-testdb"];
	mongocxx::collection coll = db["testdb"];

	// define an empty builder and many documents
	auto builder = bsoncxx::builder::stream::document{};
	std::vector<bsoncxx::document::value> documents;

	// test for insert
	auto time_start_insert = std::chrono::system_clock::now();

	for(auto& [key, value]: pairs) {
		documents.push_back(
		bsoncxx::builder::stream::document{} << key << val << finalize);
	}
	coll.write_many(documents);

	auto time_end_insert = std::chrono::system_clock::now();
	auto time_insert = std::chrono::duration_cast<std::chrono::milliseconds>(time_end_insert - time_start_insert).count();

	// test for lookup
	auto time_start_lookup = std::chrono::system_clock::now();

	mongocxx::cursor cursor = coll.find({});
	for(auto doc : cursor) {
		std::cout << bsoncxx::to_json(doc) << "\n";
	}

	auto time_end_lookup = std::chrono::system_clock::now(); 
	auto time_lookup = std::chrono::duration_cast<std::chrono::milliseconds>(time_end_lookup - time_start_lookup).count();

	// test for delete
	auto time_start_delete = std::chrono::system_clock::now();

	coll.delete_many({});

	auto time_end_delete = std::chrono::system_clock::now();
	auto time_delete = std::chrono::duration_cast<std::chrono::milliseconds>(time_end_delete - time_start_delete).count();

	// output test results
	std::cout << "Insert 1000 items time: "<< time_insert << std::endl;
	std::cout << "Lookup 1000 items time: "<< time_lookup << std::endl;
	std::cout << "Delete 1000 items time: "<< time_delete << std::endl;
	std::cout << "Total time for operations: " << time_delete+time_insert+time_lookup << std::endl;
	std::cout << "Average time for operations: " << (time_delete+time_insert+time_lookup) / 3. << std::endl;
}