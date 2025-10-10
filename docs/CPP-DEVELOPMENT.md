# C++ Development with CMake and Qt

Comprehensive guide for C++ development workflows using modern tools, CMake build system, and Qt framework integration with your dotfiles environment.

## Table of Contents

- [Quick Start](#quick-start)
- [CMake Workflows](#cmake-workflows)
- [Qt Development](#qt-development)
- [Build System Optimization](#build-system-optimization)
- [Debugging](#debugging)
- [Code Navigation](#code-navigation)
- [Testing](#testing)
- [LSP Integration](#lsp-integration)
- [Performance Analysis](#performance-analysis)
- [Common Workflows](#common-workflows)

## Quick Start

### Create New C++ CMake Project

```bash
# Create project structure
mkproject mycppapp
cd mycppapp

# Initialize git
git init

# Create CMake project structure
mkdir -p src include tests build

# Create CMakeLists.txt
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.20)
project(MyCppApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)  # For clangd LSP

# Project options
option(BUILD_TESTS "Build tests" ON)
option(ENABLE_WARNINGS "Enable compiler warnings" ON)

# Compiler flags
if(ENABLE_WARNINGS)
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Main executable
add_executable(${PROJECT_NAME}
    src/main.cpp
)

target_include_directories(${PROJECT_NAME}
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Tests
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# Installation
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)
EOF

# Create main.cpp
cat > src/main.cpp << 'EOF'
#include <iostream>

int main() {
    std::cout << "Hello, C++ World!" << std::endl;
    return 0;
}
EOF

# Configure and build
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# Run
./build/MyCppApp
```

### Open in Neovim with LSP

```bash
# Open project (LSP will auto-start)
nvim .

# Or open specific file
nvim src/main.cpp

# LSP features automatically available:
# - Code completion: <C-Space>
# - Go to definition: gd
# - Find references: gr
# - Hover documentation: K
# - Rename symbol: <leader>rn
```

## CMake Workflows

### Project Configuration

#### Basic Configuration

```bash
# Debug build (default for development)
cmake -B build -DCMAKE_BUILD_TYPE=Debug

# Release build (optimized)
cmake -B build -DCMAKE_BUILD_TYPE=Release

# Release with debug info
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo

# Minimum size release
cmake -B build -DCMAKE_BUILD_TYPE=MinSizeRel
```

#### Advanced Configuration

```bash
# Specify compiler
cmake -B build -DCMAKE_CXX_COMPILER=clang++

# Custom install prefix
cmake -B build -DCMAKE_INSTALL_PREFIX=$HOME/.local

# Use Ninja generator (faster than Make)
cmake -B build -G Ninja

# Verbose makefiles
cmake -B build -DCMAKE_VERBOSE_MAKEFILE=ON

# Enable ccache for faster rebuilds
cmake -B build -DCMAKE_CXX_COMPILER_LAUNCHER=ccache

# Multiple options at once
cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -G Ninja \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache
```

#### Interactive Configuration

```bash
# Use ccmake for interactive configuration
ccmake build

# Or CMake GUI (if installed)
cmake-gui build

# Keybindings in ccmake:
# c - configure
# g - generate and exit
# t - toggle advanced mode
# / - search
```

### Building

#### Basic Building

```bash
# Build all targets
cmake --build build

# Build specific target
cmake --build build --target mycppapp

# Parallel build (use all cores)
cmake --build build -j$(nproc)

# Verbose build output
cmake --build build --verbose

# Clean build
cmake --build build --target clean
```

#### Advanced Building

```bash
# Build only modified files
cmake --build build

# Force rebuild of everything
cmake --build build --clean-first

# Build and show compilation database
cmake --build build && cat build/compile_commands.json | jq .

# Build with different configuration
cmake --build build --config Release

# Install after build
cmake --build build --target install
```

### CMakeLists.txt Examples

#### Executable Project

```cmake
cmake_minimum_required(VERSION 3.20)
project(MyApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Sources
file(GLOB_RECURSE SOURCES "src/*.cpp")
file(GLOB_RECURSE HEADERS "include/*.h")

add_executable(${PROJECT_NAME} ${SOURCES})

target_include_directories(${PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

# Compiler warnings
target_compile_options(${PROJECT_NAME} PRIVATE
    $<$<CXX_COMPILER_ID:GNU,Clang>:-Wall -Wextra -Wpedantic>
    $<$<CXX_COMPILER_ID:MSVC>:/W4>
)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
```

#### Library Project

```cmake
cmake_minimum_required(VERSION 3.20)
project(MyLib VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Library sources
add_library(${PROJECT_NAME}
    src/mylib.cpp
    src/utils.cpp
)

# Public headers
target_include_directories(${PROJECT_NAME}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Export library
install(TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}Targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

install(DIRECTORY include/ DESTINATION include)
```

#### External Dependencies

```cmake
# Using find_package
find_package(Boost 1.70 REQUIRED COMPONENTS filesystem system)
target_link_libraries(${PROJECT_NAME} PRIVATE Boost::filesystem Boost::system)

# Using FetchContent (CMake 3.14+)
include(FetchContent)

FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG 9.1.0
)

FetchContent_MakeAvailable(fmt)
target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt)

# Using pkg-config
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK3 REQUIRED gtk+-3.0)

target_include_directories(${PROJECT_NAME} PRIVATE ${GTK3_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${GTK3_LIBRARIES})
```

### CMake in Neovim

#### Neovim CMake Integration

The dotfiles configure CMake support in Neovim automatically:

```vim
" In Neovim, CMake commands available:
:CMakeBuild              " Build project
:CMakeRun                " Run executable
:CMakeSelectBuildTarget  " Select target to build
:CMakeSelectBuildType    " Select build type (Debug/Release)
:CMakeGenerate           " Generate build files
:CMakeClean              " Clean build directory

" Keybindings (for C++ files):
<leader>cb    " CMake build
<leader>cr    " CMake run
<leader>ct    " CMake select target
<leader>cd    " CMake select build type
<leader>cg    " CMake generate
<leader>cc    " CMake clean
```

#### CMake LSP Features

```vim
" When cmake-language-server is installed:
" - Syntax highlighting in CMakeLists.txt
" - Autocompletion for CMake commands
" - Go to definition for functions/macros
" - Hover documentation for commands

" In CMakeLists.txt:
" K on a command shows documentation
" gd goes to function/macro definition
```

## Qt Development

### Qt CMake Project Template

```cmake
cmake_minimum_required(VERSION 3.20)
project(MyQtApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)  # Auto MOC for Qt
set(CMAKE_AUTOUIC ON)  # Auto UIC for .ui files
set(CMAKE_AUTORCC ON)  # Auto RCC for .qrc files
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Find Qt
find_package(Qt6 REQUIRED COMPONENTS Core Widgets Gui)

# Sources
set(SOURCES
    src/main.cpp
    src/mainwindow.cpp
)

set(HEADERS
    include/mainwindow.h
)

set(UI_FILES
    ui/mainwindow.ui
)

set(RESOURCES
    resources/resources.qrc
)

# Executable
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${HEADERS}
    ${UI_FILES}
    ${RESOURCES}
)

target_include_directories(${PROJECT_NAME} PRIVATE include)
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Widgets
    Qt6::Gui
)

# Platform-specific settings
if(WIN32)
    set_target_properties(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE TRUE)
elseif(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE TRUE)
endif()

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)
```

### Qt Development Workflow

#### Creating Qt Project from Scratch

```bash
# Create Qt project structure
mkdir myqtapp && cd myqtapp
mkdir -p src include ui resources build

# Create CMakeLists.txt (use template above)
nvim CMakeLists.txt

# Create main.cpp
cat > src/main.cpp << 'EOF'
#include <QApplication>
#include "mainwindow.h"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    MainWindow window;
    window.show();
    return app.exec();
}
EOF

# Create MainWindow header
cat > include/mainwindow.h << 'EOF'
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void onButtonClicked();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
EOF

# Create MainWindow implementation
cat > src/mainwindow.cpp << 'EOF'
#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(ui->pushButton, &QPushButton::clicked, this, &MainWindow::onButtonClicked);
}

MainWindow::~MainWindow() {
    delete ui;
}

void MainWindow::onButtonClicked() {
    // Handle button click
}
EOF

# Build and run
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j$(nproc)
./build/myqtapp
```

#### Qt UI File Editing

```bash
# Edit .ui files with Qt Designer
designer ui/mainwindow.ui &

# Or edit XML directly in Neovim (with syntax highlighting)
nvim ui/mainwindow.ui

# Preview changes
cmake --build build && ./build/myqtapp

# Regenerate UI headers after .ui changes
cmake --build build --target clean
cmake --build build
```

#### Qt Signal/Slot Debugging

```cpp
// In Neovim, use LSP to find all connections
// Place cursor on signal/slot name and press 'gr' for references

// Debug signal connections
#include <QDebug>

// Enable Qt debug output
qDebug() << "Signal emitted:" << value;

// Check if signal is connected
Q_ASSERT(connect(sender, &Sender::signal, receiver, &Receiver::slot));

// Disconnect signals for debugging
disconnect(sender, nullptr, receiver, nullptr);
```

#### Qt Documentation Lookup

```bash
# Open Qt documentation for class
qt-doc QMainWindow

# Create helper function in ~/.zshrc.local:
qt-doc() {
    xdg-open "https://doc.qt.io/qt-6/$1.html" 2>/dev/null &
}

# Usage in Neovim:
# Visual select Qt class name, then:
# :!xdg-open "https://doc.qt.io/qt-6/<C-r>""
```

### Qt Quick/QML Projects

```cmake
# CMakeLists.txt for Qt Quick
cmake_minimum_required(VERSION 3.20)
project(MyQmlApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml)

qt_add_executable(${PROJECT_NAME}
    src/main.cpp
)

qt_add_qml_module(${PROJECT_NAME}
    URI MyQmlApp
    VERSION 1.0
    QML_FILES
        qml/main.qml
        qml/Page1.qml
    RESOURCES
        images/logo.png
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Qml
)
```

## Build System Optimization

### Compiler Caching with ccache

```bash
# Install ccache
# Ubuntu:
sudo apt install ccache

# Arch:
sudo pacman -S ccache

# Configure CMake to use ccache
cmake -B build -DCMAKE_CXX_COMPILER_LAUNCHER=ccache

# Check ccache statistics
ccache -s

# Clear ccache
ccache -C

# Set maximum cache size
ccache -M 5G
```

### Parallel Builds

```bash
# Use all CPU cores
cmake --build build -j$(nproc)

# Use specific number of cores
cmake --build build -j4

# In CMakeLists.txt, set default
set(CMAKE_BUILD_PARALLEL_LEVEL ${CMAKE_BUILD_PARALLEL_LEVEL})

# Or set environment variable
export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
```

### Ninja Generator

```bash
# Install Ninja
# Ubuntu:
sudo apt install ninja-build

# Arch:
sudo pacman -S ninja

# Use Ninja generator (faster than Make)
cmake -B build -G Ninja

# Build with Ninja
cmake --build build

# Ninja advantages:
# - Faster dependency checking
# - Better parallelization
# - Cleaner output
# - Smart rebuilds
```

### Unity Builds (Jumbo Builds)

```cmake
# Enable unity builds for faster compilation
set(CMAKE_UNITY_BUILD ON)
set(CMAKE_UNITY_BUILD_BATCH_SIZE 16)

# Per-target unity build
add_executable(myapp src/main.cpp)
set_target_properties(myapp PROPERTIES UNITY_BUILD ON)
```

### Precompiled Headers

```cmake
# Create precompiled header
target_precompile_headers(${PROJECT_NAME}
    PRIVATE
        <vector>
        <string>
        <memory>
        <algorithm>
        <iostream>
)

# Reuse PCH across targets
target_precompile_headers(${PROJECT_NAME} REUSE_FROM othertarget)
```

### Link-Time Optimization (LTO)

```cmake
# Enable LTO for release builds
if(CMAKE_BUILD_TYPE MATCHES Release)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT ipo_supported)

    if(ipo_supported)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    endif()
endif()
```

### Build Time Analysis

```bash
# Measure build time
time cmake --build build

# Verbose timing with Ninja
cmake -B build -G Ninja
ninja -C build -d stats

# Per-file compilation time
cmake --build build -- VERBOSE=1 2>&1 | tee build_log.txt

# Analyze with Clang's time-trace
# Add to CMakeLists.txt:
add_compile_options(-ftime-trace)

# View trace in Chrome
# chrome://tracing
```

## Debugging

### GDB in Terminal

#### Basic GDB Commands

```bash
# Start debugging
gdb ./build/myapp

# GDB commands:
(gdb) run                       # Start program
(gdb) run arg1 arg2            # Start with arguments
(gdb) break main               # Set breakpoint at main
(gdb) break file.cpp:42        # Set breakpoint at line
(gdb) break MyClass::method    # Set breakpoint at method
(gdb) info breakpoints         # List breakpoints
(gdb) delete 1                 # Delete breakpoint 1
(gdb) continue                 # Continue execution
(gdb) next                     # Step over (n)
(gdb) step                     # Step into (s)
(gdb) finish                   # Step out
(gdb) print variable           # Print variable value
(gdb) print *pointer           # Dereference pointer
(gdb) display variable         # Auto-display variable
(gdb) backtrace                # Show call stack (bt)
(gdb) frame 3                  # Switch to frame 3
(gdb) up/down                  # Move up/down stack
(gdb) list                     # Show source code
(gdb) quit                     # Exit GDB
```

#### Advanced GDB Usage

```bash
# Attach to running process
gdb -p <pid>

# Debug core dump
gdb ./myapp core.12345

# Conditional breakpoints
(gdb) break file.cpp:42 if x > 100

# Watch variable changes
(gdb) watch variable
(gdb) rwatch variable          # Read watch
(gdb) awatch variable          # Access watch

# Pretty-printing STL containers
(gdb) print vector
(gdb) print /r vector          # Raw format

# Call functions during debugging
(gdb) call function(arg)
(gdb) print function(arg)

# Set variable values
(gdb) set variable x = 10

# Thread debugging
(gdb) info threads
(gdb) thread 2                 # Switch to thread 2
(gdb) thread apply all bt      # Backtrace all threads
```

#### GDB with TUI Mode

```bash
# Start GDB in TUI mode
gdb -tui ./build/myapp

# TUI commands:
Ctrl+X A    # Toggle TUI mode
Ctrl+X 1    # Single window
Ctrl+X 2    # Split layout
Ctrl+L      # Refresh screen
Ctrl+P/N    # Command history

# TUI windows:
(gdb) layout src               # Source window
(gdb) layout asm               # Assembly window
(gdb) layout split             # Source and assembly
(gdb) layout regs              # Register window
(gdb) focus cmd                # Focus command window
(gdb) focus src                # Focus source window
```

### GDB in Neovim

#### Neovim Debugging Setup

The dotfiles configure Neovim for debugging. Use `nvim-dap` for debugging:

```vim
" Install nvim-dap and nvim-dap-ui through Lazy.nvim
" Configuration in init.lua handles C++ debugging

" Debugging keybindings:
<F5>         " Start/Continue debugging
<F10>        " Step over
<F11>        " Step into
<F12>        " Step out
<leader>db   " Toggle breakpoint
<leader>dB   " Conditional breakpoint
<leader>dr   " Open REPL
<leader>dl   " Run last configuration

" In debug mode:
K            " Evaluate expression under cursor
```

#### Configure DAP for C++

```lua
-- In ~/.config/nvim/lua/user/dap.lua or init.lua
local dap = require('dap')

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/path/to/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    setupCommands = {
      {
        description = 'Enable pretty-printing',
        text = '-enable-pretty-printing',
        ignoreFailures = false
      },
    },
  },
}
```

### Memory Debugging with Valgrind

```bash
# Install Valgrind
# Ubuntu:
sudo apt install valgrind

# Arch:
sudo pacman -S valgrind

# Basic memory leak check
valgrind --leak-check=full ./build/myapp

# Comprehensive check
valgrind \
    --leak-check=full \
    --show-leak-kinds=all \
    --track-origins=yes \
    --verbose \
    --log-file=valgrind.log \
    ./build/myapp

# Check for memory errors
valgrind --tool=memcheck ./build/myapp

# Cache profiling
valgrind --tool=cachegrind ./build/myapp
callgrind_annotate cachegrind.out.<pid>

# Heap profiling
valgrind --tool=massif ./build/myapp
ms_print massif.out.<pid>
```

### AddressSanitizer (ASan)

```cmake
# Enable AddressSanitizer in CMakeLists.txt
if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_compile_options(-fsanitize=address -fno-omit-frame-pointer)
    add_link_options(-fsanitize=address)
endif()
```

```bash
# Build with ASan
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# Run with ASan
ASAN_OPTIONS=detect_leaks=1:symbolize=1 ./build/myapp

# Generate suppressions
ASAN_OPTIONS=detect_leaks=1:print_suppressions=1 ./build/myapp 2>&1 | tee asan.log
```

### Thread Sanitizer (TSan)

```cmake
# Enable ThreadSanitizer
add_compile_options(-fsanitize=thread -fno-omit-frame-pointer)
add_link_options(-fsanitize=thread)
```

```bash
# Run with TSan
TSAN_OPTIONS="second_deadlock_stack=1" ./build/myapp
```

### UndefinedBehaviorSanitizer (UBSan)

```cmake
# Enable UBSan
add_compile_options(-fsanitize=undefined -fno-omit-frame-pointer)
add_link_options(-fsanitize=undefined)
```

## Code Navigation

### LSP-Based Navigation (clangd)

#### Setup clangd

```bash
# Install clangd
# Ubuntu:
sudo apt install clangd

# Arch:
sudo pacman -S clang

# Verify installation
clangd --version

# Generate compile_commands.json (required for clangd)
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# Symlink to project root
ln -s build/compile_commands.json .
```

#### Neovim LSP Keybindings

```vim
" LSP navigation (automatically configured):
gd          " Go to definition
gD          " Go to declaration
gi          " Go to implementation
gr          " Find references
K           " Hover documentation
<C-k>       " Signature help
<leader>rn  " Rename symbol
<leader>ca  " Code actions
[d          " Previous diagnostic
]d          " Next diagnostic
<leader>e   " Show diagnostic float

" Telescope LSP pickers:
<leader>ls  " Document symbols
<leader>lw  " Workspace symbols
<leader>ld  " Document diagnostics
<leader>lD  " Workspace diagnostics
```

#### clangd Features in Neovim

```bash
# In C++ file in Neovim:

# 1. Code completion
# Type and press <C-Space> for suggestions

# 2. Include completion
#include <vec|    # <C-Space> shows <vector>

# 3. Member completion
std::vector<int> v;
v.|               # Shows all vector members

# 4. Parameter hints
std::make_unique|  # Shows template parameters

# 5. Quick fixes
# Place cursor on error, press <leader>ca

# 6. Inlay hints (if enabled)
# Shows parameter names inline
```

### Header/Source Switching

```vim
" In Neovim for C++ files:
<leader>ch      " Switch between header and source (ClangdSwitchSourceHeader)

" Or use Telescope:
<leader>f       " Find files, type filename
```

```bash
# Command line header/source switching with fzf
# Add to ~/.zshrc.local:
hsswitch() {
    local current="$1"
    local base="${current%.*}"
    local ext="${current##*.}"

    if [[ "$ext" == "cpp" ]] || [[ "$ext" == "cc" ]]; then
        fd -e h -e hpp "$base" | head -1 | xargs nvim
    elif [[ "$ext" == "h" ]] || [[ "$ext" == "hpp" ]]; then
        fd -e cpp -e cc "$base" | head -1 | xargs nvim
    fi
}
```

### ctags Integration

```bash
# Install universal-ctags
# Ubuntu:
sudo apt install universal-ctags

# Arch:
sudo pacman -S ctags

# Generate tags for project
ctags -R --c++-kinds=+p --fields=+iaS --extras=+q .

# Or use fd for better filtering
fd -e cpp -e h -e hpp -x ctags -a {}

# In Vim/Neovim:
Ctrl+]      " Jump to tag
Ctrl+T      " Jump back
:tag symbol " Jump to symbol
:ts         " List tags
:tn/:tp     " Next/previous tag
```

### Include-What-You-Use (IWYU)

```bash
# Install IWYU
# Ubuntu:
sudo apt install iwyu

# Arch:
yay -S include-what-you-use

# Run IWYU on single file
include-what-you-use -Xiwyu --error=1 file.cpp

# Run IWYU on whole project
cmake -B build -DCMAKE_CXX_INCLUDE_WHAT_YOU_USE="include-what-you-use;-Xiwyu;--error=1"
cmake --build build 2>&1 | tee iwyu.log

# Apply IWYU suggestions
fix_includes.py < iwyu.log

# Create wrapper script ~/bin/iwyu-check.sh:
#!/bin/bash
include-what-you-use \
    -Xiwyu --error=1 \
    -Xiwyu --mapping_file=iwyu.imp \
    "$@"
```

## Testing

### Google Test Integration

```cmake
# CMakeLists.txt with Google Test
include(FetchContent)

FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG release-1.12.1
)

FetchContent_MakeAvailable(googletest)

enable_testing()

add_executable(myapp_test
    tests/test_main.cpp
    tests/test_myclass.cpp
)

target_link_libraries(myapp_test
    PRIVATE
    GTest::gtest_main
    mylib
)

include(GoogleTest)
gtest_discover_tests(myapp_test)
```

```cpp
// tests/test_myclass.cpp
#include <gtest/gtest.h>
#include "myclass.h"

TEST(MyClassTest, BasicAssertions) {
    MyClass obj;
    EXPECT_EQ(obj.getValue(), 42);
    EXPECT_TRUE(obj.isValid());
}

TEST(MyClassTest, EdgeCases) {
    MyClass obj;
    obj.setValue(0);
    EXPECT_EQ(obj.getValue(), 0);
}
```

### Running Tests

```bash
# Build and run tests
cmake --build build
ctest --test-dir build

# Verbose test output
ctest --test-dir build --verbose

# Run specific test
ctest --test-dir build -R MyClassTest

# Run tests in parallel
ctest --test-dir build -j$(nproc)

# Show test output on failure
ctest --test-dir build --output-on-failure

# Run with Neovim:
# :CMakeTest
```

### Test Coverage

```cmake
# Enable coverage in CMakeLists.txt
if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_compile_options(--coverage)
    add_link_options(--coverage)
endif()
```

```bash
# Build with coverage
cmake -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build

# Run tests
ctest --test-dir build

# Generate coverage report
lcov --capture --directory build --output-file coverage.info
lcov --remove coverage.info '/usr/*' '*/tests/*' --output-file coverage_filtered.info
genhtml coverage_filtered.info --output-directory coverage_report

# Open report
xdg-open coverage_report/index.html
```

## LSP Integration

### clangd Configuration

Create `.clangd` in project root:

```yaml
# .clangd configuration
CompileFlags:
  Add:
    - "-std=c++17"
    - "-Wall"
    - "-Wextra"
  Remove:
    - "-W*"  # Remove all warning flags, then add back specific ones

Diagnostics:
  ClangTidy:
    Add:
      - readability-*
      - performance-*
      - modernize-*
    Remove:
      - readability-magic-numbers
  UnusedIncludes: Strict

InlayHints:
  Enabled: Yes
  ParameterNames: Yes
  DeducedTypes: Yes

Hover:
  ShowAKA: Yes
```

### CMake LSP

```bash
# Install cmake-language-server
pip install cmake-language-server

# Neovim will auto-configure for CMakeLists.txt files
```

## Performance Analysis

### Profiling with gprof

```cmake
# Enable profiling
add_compile_options(-pg)
add_link_options(-pg)
```

```bash
# Build and run
cmake --build build
./build/myapp

# Generate report
gprof ./build/myapp gmon.out > analysis.txt
bat analysis.txt
```

### Profiling with perf

```bash
# Record performance data
perf record -g ./build/myapp

# View report
perf report

# Generate flamegraph
perf script | stackcollapse-perf.pl | flamegraph.pl > flamegraph.svg
xdg-open flamegraph.svg
```

### Memory Profiling with Heaptrack

```bash
# Install heaptrack
# Ubuntu:
sudo apt install heaptrack heaptrack-gui

# Arch:
sudo pacman -S heaptrack

# Profile application
heaptrack ./build/myapp

# View results
heaptrack_gui heaptrack.myapp.12345.gz
```

## Common Workflows

### Complete Development Session in Tmux

```bash
# Create development session
tmux new-session -s cpp-dev -c ~/Projects/myapp

# Window 1: Editor
nvim .

# Split for terminal
<Ctrl+a> |

# Window 2: Build/Run
<Ctrl+a> c
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j$(nproc)

# Window 3: Tests
<Ctrl+a> c
watch -n 2 'cmake --build build && ctest --test-dir build --output-on-failure'

# Window 4: Git
<Ctrl+a> c
lg  # lazygit
```

### Code Review Workflow

```bash
# Review changes
git diff main...feature-branch | bat

# Review specific file
git show feature-branch:src/main.cpp | bat -l cpp

# Compare in Neovim
nvim -d main_version.cpp feature_version.cpp

# Interactive staging
git add -p src/main.cpp
```

### Refactoring Workflow

```vim
" In Neovim:
" 1. Find all references
gr

" 2. Rename symbol
<leader>rn

" 3. Apply code action
<leader>ca

" 4. Format code
<leader>cf
```

### Release Build and Package

```bash
# Configure for release
cmake -B build-release \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -G Ninja

# Build
cmake --build build-release -j$(nproc)

# Run tests
ctest --test-dir build-release

# Install to staging
cmake --install build-release --prefix ./install-staging

# Create package
cd build-release
cpack -G TGZ
cpack -G DEB  # or RPM for Fedora/Arch
```

## Troubleshooting

### CMake Issues

```bash
# Clear CMake cache
rm -rf build/CMakeCache.txt build/CMakeFiles

# Or start fresh
rm -rf build && cmake -B build

# Debug CMake configuration
cmake -B build --trace

# Check CMake variables
cmake -B build -L
cmake -B build -LA  # Advanced variables
```

### LSP Not Working

```bash
# Check clangd is running
ps aux | grep clangd

# Check compile_commands.json exists
ls -l compile_commands.json

# Restart LSP in Neovim
:LspRestart

# Check LSP logs
:LspLog
```

### Build Errors

```bash
# Verbose build output
cmake --build build -- VERBOSE=1

# Show compilation database
cat build/compile_commands.json | jq '.[0]'

# Check include paths
echo | clang++ -E -Wp,-v -xc++ - 2>&1 | grep '^ '
```

## Additional Resources

- [CMake Documentation](https://cmake.org/documentation/)
- [Qt Documentation](https://doc.qt.io/)
- [clangd Documentation](https://clangd.llvm.org/)
- [Google Test](https://google.github.io/googletest/)
- [Modern CMake](https://cliutils.gitlab.io/modern-cmake/)
- [Awesome CMake](https://github.com/onqtam/awesome-cmake)

## Next Steps

- Review [VIM-NEOVIM-ADVANCED.md](VIM-NEOVIM-ADVANCED.md) for editor mastery
- See [PACKAGE-MANAGEMENT.md](PACKAGE-MANAGEMENT.md) for dependency management
- Check [KUBERNETES-HOMELAB.md](KUBERNETES-HOMELAB.md) for deployment workflows
