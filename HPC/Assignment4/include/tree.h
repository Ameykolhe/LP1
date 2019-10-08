#ifndef TREE
#define TREE

class Node {
    public:
    
    int data;
    Node *left,*right;
    
    Node() {
        left = NULL;
        right = NULL;
    }

    Node(int data) {
        this->data = data;
        left = NULL;
        right = NULL;
    }
    
};

class Tree {
    public:

    Node *root;

    Tree() {
        root = NULL;
    }

    void insertNode(int );

    void traverse(Node *);
};

#endif