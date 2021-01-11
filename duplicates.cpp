// Copyright @ Roman Balayan [2021]

#include "duplicates.h"

const size_t BLOCK_LEN = 1024; // length of the blocks to hasn in bytes

Directory::Directory(fs::path dirPath) : path(dirPath)
{
    if (fs::is_directory(this->path)) {
        for(fs::recursive_directory_iterator itr(this->path), end_itr; itr != end_itr; ++itr){
            if (is_regular_file(itr->path())) { // will not save the directories
                size_t file_size = fs::file_size(itr->path());
                this->files.insert(std::pair<size_t, File*>(file_size, new File(*itr)));
            }
        }
    }
}

Directory::~Directory()
{
    for (auto el : this->files)
        delete el.second;
}

void Directory::setFiles()
{
    if (fs::is_directory(this->path)) {
        for (fs::recursive_directory_iterator itr(this->path), end_itr; itr != end_itr; ++itr) {
            if (is_regular_file(itr->path())) { // will not save the directories
                size_t file_size = fs::file_size(itr->path());
                this->files.insert(std::pair<size_t, File*>(file_size, new File(*itr)));
            }
        }
    }
}

void Directory::findDuplicates(Directory* secondDir)
{
    for (auto pair : this->files) {
        // does second dir contain files with the same size?
        if (secondDir->files.count(pair.first) > 0) {
            // going through the files with the same size in the second directory
            auto range = secondDir->files.equal_range(pair.first); // iterators of the files in the second dir with the same size
            for (auto secDirFileItr = range.first, end_itr = range.second; secDirFileItr != end_itr; ++secDirFileItr) {
                if (*pair.second == *secDirFileItr->second)
                    duplicates.push_back(std::pair<File*, File*>(pair.second, secDirFileItr->second));
            }
        }
    }
}

bool File::operator==(File& file2)
{
    if (fs::file_size(this->value.path()) != fs::file_size(file2.value.path()))
        return false;
    char* buf = new char[BLOCK_LEN + 1];
    std::ifstream is1(this->value.path().string(), std::ifstream::binary); // input stream for the first file
    std::ifstream is2(file2.value.path().string(), std::ifstream::binary); // input stream for the second file
    size_t block_id = 0;
    size_t blocks_amount = fs::file_size(this->value.path()) / BLOCK_LEN;
    while (!is1.eof() && block_id < blocks_amount) {
        std::string hashed1;
        std::string hashed2;

        // does we have this block?
        if (block_id >= this->md5hashes.size())
        {
            is1.seekg(BLOCK_LEN * block_id); // set cursor to the begining of the needed block
            is1.read(buf, BLOCK_LEN); // reading block from the first file
            if (is1)
                buf[BLOCK_LEN] = '\0';
            else
                buf[is1.gcount()] = '\0';
            hashed1 = md5(buf); // hashing the block
            this->md5hashes.push_back(hashed1); // save the hash for this file
        }
        else
            hashed1 = this->md5hashes[block_id]; // get saved hash
        // does we have this block?
        if (block_id >= file2.md5hashes.size()) {
            is2.seekg(BLOCK_LEN * block_id); // set cursor to the begining of the needed block
            is2.read(buf, BLOCK_LEN); // reading block from the second file
            if (is2)
                buf[BLOCK_LEN] = '\0';
            else
                buf[is2.gcount()] = '\0';
            hashed2 = md5(buf); // hashing the block
            file2.md5hashes.push_back(hashed2);
        }
        else
            hashed2 = file2.md5hashes[block_id];
        if (hashed1 != hashed2) // comparing the hashes of blocks from different files
        {
            delete [] buf;
            return false;
        }
        block_id++;
    }
    delete [] buf;
    return true;
}

fs::path File::getPath()
{
    return this->value.path();
}
