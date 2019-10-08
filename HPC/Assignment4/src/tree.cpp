#include <iostream>
#include "tree.h"

using namespace std;

void Tree::insertNode(int data) {
    if(root == NULL) {
        root = new Node(data);
    }
    else {
        Node *temp = root;
        while(true) {
            if(temp->data > data) {
                if(temp->left == NULL) {
                    temp->left = new Node(data);
                    break;
                }
                else {
                    temp = temp->left;
                }
            }
            else {
                if(temp->right == NULL) {
                    temp->right = new Node(data);
                    break;
                }
                else {
                    temp = temp->right;
                }
            }
        }
    }
}


void Tree::traverse(Node *temp) {
    if(temp == NULL) {
        return;
    }
    traverse(temp->left);
    cout<<temp->data<<"    ";
    traverse(temp->right);
}