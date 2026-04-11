import matplotlib.pyplot as plt
import pandas as pd
plt.style.use('ggplot')
# Create colors
wcprimary = (78/255,42/255,132/255)
df = pd.read_stata("source/graphs/auto.dta")
plt.scatter(df["weight"], df["mpg"], color=wcprimary)
plt.xlabel("Weight")
plt.ylabel("MPG")
plt.savefig("source/graphs/plot-python.pdf")
plt.show()
