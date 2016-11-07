importPackage(javax.swing); 
importPackage(java.awt);  
importClass(javax.swing.border.EmptyBorder); 
importClass(java.awt.event.ActionListener);
importClass(java.awt.event.KeyEvent); 
importClass(java.lang.Thread);

/*
 * Supported arithmetic functions.
 */
function add(x, y) {
  return x + y;
}

function minus(x, y) {
  return x - y;
}

function multiply(x, y) {
  return x * y;
}

function divide(x, y) {
  return x / y;
}

/*
 * Calculator appearance customization
 */
var font = new Font("Tahoma", Font.BOLD, 18);
var widgetDimension = 60;
var buttonColumns = 4;
var buttonRows = 5;

/*
 * Support for keyboard keys
 */
var keyboardMappings = {
  "0": KeyEvent.VK_0,
  "1": KeyEvent.VK_1,
  "2": KeyEvent.VK_2,
  "3": KeyEvent.VK_3,
  "4": KeyEvent.VK_4,
  "5": KeyEvent.VK_5,
  "6": KeyEvent.VK_6,
  "7": KeyEvent.VK_7,
  "8": KeyEvent.VK_8,
  "9": KeyEvent.VK_9,
  "+": 43, //KeyEvent.VK_PLUS does not work, see http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4262044
  "-": KeyEvent.VK_MINUS,
  "/": 47, //KeyEvent.VK_DIVIDE does not work
  "*": 42, //KeyEvent.VK_MULTIPLY does not work
  "=": KeyEvent.VK_EQUALS
};
var keyboardHandlers = {};

/*
 * Support for chaining computations
 */
var lastComputation = {operator: null, value: null}
var clearOnNextSymbol = false

/*
 * Laying out the Calculator's controls
 */
var frame = new JFrame("Rhino Calculator");
var layout = new GridBagLayout();
frame.getContentPane().setLayout(layout);

var resultField = addResultField();
var buttonsPanel = addButtonsPanel();
addCalculatorButtons();

frame.pack(); 
frame.setResizable(false);
frame.visible = true;

frame.addWindowListener(function(e, name) { 
  if ("windowClosing" === name)  {
    java.lang.System.exit(0);
  } 
});  

function addResultField() {
  var resultField = new JTextField();
  resultField.setPreferredSize(new Dimension(buttonColumns * widgetDimension, widgetDimension));
  resultField.setHorizontalAlignment(JTextField.RIGHT);
  resultField.setFont(font);
  resultField.setEditable(false);
  resultField.setBackground(Color.WHITE);
  resultField.addKeyListener(keyboardListener);
  resultField.text = "0";

  var constraints = new GridBagConstraints();
  constraints.gridx = 0
  constraints.gridy = 0
  constraints.gridwidth = buttonColumns
  constraints.gridheight = 1
  frame.add(resultField, constraints);
  return resultField;
}

function addButtonsPanel() {
  var buttonsPanel = new JPanel();
  var constraints = new GridBagConstraints();
  constraints.gridx = 0
  constraints.gridy = 1
  constraints.gridwidth = buttonColumns
  constraints.gridheight = buttonRows
  var buttonsPanelLayout = new GridLayout(buttonRows, buttonColumns);
  buttonsPanel.setLayout(buttonsPanelLayout);
  frame.add(buttonsPanel, constraints);
  return buttonsPanel;
}

function addCalculatorButtons() {
  for (var i = 0; i <= 9; i++) {
    addNumberButton(i.toString());
  }
  addSignButton();
  addDotButton();
  addOperatorButton("+", add);
  addOperatorButton("-", minus);
  addOperatorButton("*", multiply);
  addOperatorButton("/", divide);
  addOperatorButton("=");
  addCancelEntryButton();
  addCancelButton();
}

function addNumberButton(number) {
  addButton(number, function() {
    if (clearOnNextSymbol) {
      setDisplay(number);
      clearOnNextSymbol = false;
    } else {
      setDisplay(resultField.text + number);
    }    
  });
}

function addOperatorButton(operatorSymbol, operator) {
  addButton(operatorSymbol, function() {
    if ((lastComputation.operator != null) && (lastComputation.value != null)) {
      var inputValue = parseFloat(resultField.text);
      setDisplay(lastComputation.operator.call(this, lastComputation.value, inputValue));
    }
    if (operator != null) {
      lastComputation = {operator: operator, value: parseFloat(resultField.text)};
    } else {
      lastComputation = {operator: null, value: null};
    }
    clearOnNextSymbol = true
  });
}

function addSignButton() {
  addButton("+-", function() {
    if (resultField.text.startsWith("-")) {
      setDisplay(resultField.text.substring(1));
    } else {
      setDisplay("-" + resultField.text);
    }
  });
}

function addDotButton() {
  addButton(".", function() {
    var indexOfDot = resultField.text.indexOf(".");
    if (indexOfDot >= 0) {
      setDisplay(resultField.text.substring(0, indexOfDot));
    } else {
      if (clearOnNextSymbol) {
        setDisplay("0.");
        clearOnNextSymbol = false;
      } else {
        setDisplay(resultField.text + ".");
      }
    }
  });
}

function addCancelEntryButton() {
  addButton("CE", function() {
    setDisplay("0");
  });
}

function addCancelButton() {
  addButton("C", function() {
    setDisplay("0");
    lastComputation = {operator: null, value: null};
  });
}

function addButton(buttonLabel, eventHandler) {
  var button = new JButton(buttonLabel);
  button.setPreferredSize(new Dimension(widgetDimension, widgetDimension));
  button.setFont(font);
  registerKeyboardEventHandlerIfDefined(buttonLabel, eventHandler);
  button.addActionListener(function() {
    eventHandler.call(null);
  });
  button.addKeyListener(keyboardListener);
  buttonsPanel.add(button);
}

function registerKeyboardEventHandlerIfDefined(buttonLabel, eventHandler) {
  var keyboardKey = keyboardMappings[buttonLabel];
  if (undefined !== keyboardKey) {
    keyboardHandlers[keyboardKey] = eventHandler;
  }
}

function keyboardListener(event, name) {
  if ("keyTyped" === name)  {
    keyboardHandler = keyboardHandlers[event.getKeyChar()];
    if (undefined !== keyboardHandler) {
      keyboardHandler.call(null);
    }
  }
}

function setDisplay(content) {
  resultField.text = content;
  removeLeadingZeroIfNeeded();
}

function removeLeadingZeroIfNeeded() {
  var leadingZeroRegex = new RegExp("^0[0-9]+");
  match = leadingZeroRegex.exec(resultField.text);
  if (null !== match) {
    resultField.text = resultField.text.substring(1);
  }
}
