# Compiler
CXX = g++

# Compiler flags
CXXFLAGS = -std=c++23 -Wall -g -O2 -MMD -MP

# Define all directory names
BINDIR = bin
DOCDIR = doc
OBJDIR = obj
INCDIR = inc
SANDIR = sandbox
SRCDIR = src
TESDIR = test
FOLDERS = $(BINDIR) $(DOCDIR) $(OBJDIR) $(INCDIR) $(SANDIR) $(SRCDIR)

# Add all directories that contain header files used in this project to the _INCLUDE variable
_INCLUDE = $(INCDIR)
# Includes with the "-I" prefix added
INCLUDES = $(addprefix -I,$(_INCLUDE))

# List all objects to built
OBJECT_LIST = main.o
# This variable contains the full path of all objects
OBJECTS = $(addprefix $(OBJDIR)/,$(OBJECT_LIST))

# Main target
TARGET_ = program
# Target variable with full path
TARGET = $(addprefix $(BINDIR)/,$(TARGET_))

# Rule to make the main target executable
$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(OBJECTS) -o $(TARGET)

# Rule to make each object
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(INCDIR)/%.h
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Rule to allow us to use the name of an object without including the full path on the command line
%.o: $(OBJDIR)/%.o
	@echo "$@ ... done"

# Clean up all objects and executables
clean:
	rm -f $(OBJECTS) $(OBJECTS:.o=.d) $(TARGET)

all: $(TARGET)

# Set the arguments with which to run the executable
ARGS = some example arguments

# Run the executable
run: $(TARGET)
	./$(TARGET).exe $(ARGS)

# Debug the executable using gdb
debug: $(TARGET)
	gdb --args $(TARGET) $(ARGS)

# Generate the folders for this project
folders:
	mkdir -p $(FOLDERS) $(addprefix $(TESDIR)/,$(FOLDERS))

.PHONY: clean run all folders