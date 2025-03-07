import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QLabel, QSpinBox, QPushButton
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
from julia import Main

# Caminhos relativos ao diretório raiz
Main.include("../backend_julia/src/Profiles.jl")
Main.include("../backend_julia/src/Routine.jl")
Main.include("../backend_julia/src/simul.jl")

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Simulação de Rotinas")
        self.setGeometry(100, 100, 800, 600)
        
        layout = QVBoxLayout()
        
        self.size_label = QLabel("Número de simulações:")
        self.size_spinbox = QSpinBox()
        self.size_spinbox.setRange(1, 10000)
        self.size_spinbox.setValue(1000)
        
        self.run_button = QPushButton("Executar Simulação")
        self.run_button.clicked.connect(self.run_simulation)
        
        self.figure = Figure()
        self.canvas = FigureCanvas(self.figure)
        self.ax = self.figure.add_subplot(111)
        
        layout.addWidget(self.size_label)
        layout.addWidget(self.size_spinbox)
        layout.addWidget(self.run_button)
        layout.addWidget(self.canvas)
        
        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)
    
    def run_simulation(self):
        tamanho = self.size_spinbox.value()
        self.ax.clear()
        Main.simul(self.ax, tamanho)
        self.canvas.draw()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())