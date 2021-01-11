// Copyright @ Roman Balayan [2021]

#ifndef _DUPLICATES_H_
#define _DUPLICATES_H_

#include <boost/filesystem.hpp>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_map>

#include "md5.h"

namespace fs = boost::filesystem;

class File {
private:
    fs::directory_entry value;
    std::vector<std::string> md5hashes;
public:
    File(fs::directory_entry val) : value(val) {

    }
    bool operator==(File& file2);
    //bool cmp(File& file2, size_t threadId);
    fs::path getPath();
};

class Directory {
private:
    std::unordered_multimap<size_t, File* > files; // key - size of file, value - file
    std::vector<std::pair<File*, File*> > duplicates; // will store duplicates in the vector by pairs
    fs::path path; // path of directory
public:
    Directory(){
    
    }
    Directory(fs::path dirPath);
    ~Directory();
    //void setDir();
    void setFiles();
    void findDuplicates(Directory* secondDir);
    inline auto getDuplicates() -> decltype (this->duplicates){
        return this->duplicates;
    }
    void printDuplicates();
};

#endif // _DUPLICATES_H_

