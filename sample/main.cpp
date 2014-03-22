#include <iostream>
#include <string>
#include <stdlib.h>

int main() {
    int continued;
    int score, best;
    int board[4][4];
    std::string cmds[] = { "up", "right", "down", "left" };
    srand(time(NULL));
    while(true) {
        std::cin >> continued;
        std::cin >> score >> best;
        for (int y = 0; y < 4; y++) {
            for (int x = 0; x < 4; x++) {
                std::cin >> board[y][x];
            }
        }
        if (!continued) {
            std::cout << "exit" << std::endl;
            std::cout.flush();
            break;
        }
        std::cout << cmds[rand() % 4] << std::endl;
        std::cout.flush();
    }
    return 0;
}