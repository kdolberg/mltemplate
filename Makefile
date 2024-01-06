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
LIBDIR = lib
FOLDERS = $(BINDIR) $(DOCDIR) $(OBJDIR) $(INCDIR) $(SANDIR) $(SRCDIR) $(LIBDIR)

LIBRARIES = $(wildcard $(LIBDIR)/*)
REPOS = . $(LIBRARIES)
VPATH = $(REPOS)

DEP = $(wildcard $(OBJDIR)/*.d)
include $(DEP)

# Add all directories that contain header files used in this project to the _INCLUDE variable
_INCLUDE = $(INCDIR) $(addsuffix /inc,$(REPOS)) $(REPOS)
# Includes with the "-I" prefix added
INCLUDES = $(addprefix -I,$(_INCLUDE))

SRC = $(wildcard $(addsuffix /src/*.cpp,$(REPOS)))

# Main target
_TARGET = mldg
# Target variable with full path
TARGET = $(addprefix $(BINDIR)/,$(_TARGET))

.DEFAULT_GOAL := $(TARGET)

# This variable contains the full path of all objects
OBJECTS = $(patsubst %.cpp,%.o,$(addprefix $(OBJDIR)/, $(notdir $(SRC))))

# For colouring output text
CL1=\033[0;34m
CL2=\033[0;35m
NC=\033[0m# No Color

# Rule to make the main target executable
$(TARGET): $(OBJECTS)
	@mkdir -p $(BINDIR)
	@echo -e "Building $(CL2)$(notdir $@)$(NC) (prereqs: $(CL2)$(sort $(notdir $^))$(NC))"
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(OBJECTS) -o $(TARGET)
	@echo "done."

# Rule to make each object
$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(INCDIR)/%.h
	@echo -e "Building $(CL1)$(notdir $@)$(NC) (prereqs: $(CL1)$(notdir $^)$(NC)) ... "
	@mkdir -p $(OBJDIR) $(OBJDIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Rule to allow us to use the name of an object without including the full path on the command line
%.o: $(OBJDIR)/%.o
	@echo "$@ ... done"

# Clean up all objects and executables
clean:
	rm -f $(OBJECTS) $(TARGET)

all: $(TARGET)

# Set the arguments with which to run the executable
ARGS = 1000

# Run the executable
run: $(TARGET)
	./$(TARGET).exe $(ARGS)

# Debug the executable using gdb
debug: $(TARGET)
	gdb --args $(TARGET) $(ARGS)

# Generate the folders for this project
folders:
	mkdir -p $(FOLDERS) $(addprefix $(TESDIR)/,$(FOLDERS))

libraries:
	@echo $(LIBRARIES)

dep:
	@echo $(DEP)

src:
	@echo $(SRC)

obj:
	@echo $(OBJECTS)

all_obj: $(OBJECTS)

clean_all:
	rm -f $(OBJECTS) $(DEP)

.PHONY: clean run all folders libraries dep all_obj src obj clean_all