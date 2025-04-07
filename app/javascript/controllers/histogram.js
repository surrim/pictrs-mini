import "chart.js";

function getHistogram(src) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = function () {
      const canvas = document.createElement("canvas");
      canvas.width = img.naturalWidth;
      canvas.height = img.naturalHeight;

      const context = canvas.getContext("2d");
      context.drawImage(img, 0, 0);

      const data = context.getImageData(0, 0, canvas.width, canvas.height).data;
      const histogram = {
        red: new Uint32Array(256),
        green: new Uint32Array(256),
        blue: new Uint32Array(256),
        alpha: new Uint32Array(256),
        gray: new Uint32Array(256),
        has_alpha: false,
        is_grayscale: true,
      };
      for (let i = 0; i < data.length; i += 4) {
        const [red, green, blue, alpha] = [
          data[i],
          data[i + 1],
          data[i + 2],
          data[i + 3],
        ];

        // Using Rec._709 luma coefficients, without floating point multiplications
        // See https://en.wikipedia.org/wiki/Rec._709#Luma_coefficients
        // const gray = red * 0.2126 + green * 0.7152 + blue * 0.0722;
        const gray =   (red * 6966   + green * 23436  + blue * 2366) >> 15; 

        if (!histogram.has_alpha && alpha != 255) {
          histogram.has_alpha = true;
        }
        if (histogram.is_grayscale && (red != green || green != blue)) {
          histogram.is_grayscale = false;
        }
        histogram.red[red]++;
        histogram.green[green]++;
        histogram.blue[blue]++;
        histogram.alpha[alpha]++;
        histogram.gray[gray]++;
      }
      resolve(histogram);
    };
    img.onerror = function () {
      reject(new Error("Image failed to load."));
    };
    img.src = src;
  });
}

function toDataset(label, color, data, opts) {
  return {
    label: label,
    data: data,
    pointStyle: false,
    borderColor: color,
    tension: 0.1,
    ...opts,
  };
}

function toDatasets(histogram) {
  const datasets = [];
  if (!histogram.is_grayscale) {
    datasets.push(
      toDataset("Red", "red", histogram.red),
      toDataset("Green", "green", histogram.green),
      toDataset("Blue", "blue", histogram.blue)
    );
  }
  datasets.push(
    toDataset("Brightness", "gray", histogram.gray, {
      hidden: !histogram.is_grayscale,
    })
  );
  if (histogram.has_alpha) {
    datasets.push(
      toDataset("Alpha", "black", histogram.alpha, { hidden: true })
    );
  }
  return datasets;
}

function toConfig(histogram) {
  return {
    type: "line",
    data: {
      labels: Array.from({ length: 256 }, (_, i) => i),
      datasets: toDatasets(histogram),
    },
    options: {
      scales: {
        y: { min: 0 },
      },
    },
  };
}

function updateHistogramCanvases() {
  for (const canvas of document.querySelectorAll(
    "canvas[data-histogram-src]"
  )) {
    if (canvas.dataset.histogramCreated) { // skip already created charts
      continue;
    }
    const src = canvas.dataset.histogramSrc;
    const histogram = getHistogram(src)
      .then((histogram) => {
        const config = toConfig(histogram);
        const ctx = canvas.getContext("2d");
        new Chart(ctx, config);
        canvas.dataset.histogramCreated = true;
      })
      .catch((error) => {
        console.error(error);
      });
  }
}

document.addEventListener("DOMContentLoaded", updateHistogramCanvases);
document.addEventListener("turbo:load", updateHistogramCanvases);
