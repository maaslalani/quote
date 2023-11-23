document.getElementById('export').addEventListener('click', exportImage);

const quote = document.querySelector('.quote');
const quoteMask = document.querySelector('.quote-mask');

document.querySelectorAll('.theme').forEach(a => {
  const foreground = a.getAttribute('data-fg');
  const background = a.getAttribute('data-bg');
  a.style.backgroundColor = background;
  a.style.color = foreground;
  a.addEventListener('click', () => {
    quote.style.backgroundColor = background;
    quote.style.color = foreground;
  });
})

document.querySelectorAll('.padding').forEach(a => {
  const padding = a.getAttribute('data-padding');
  a.addEventListener('click', () => {
    quote.style.paddingLeft = padding;
    quote.style.paddingRight = padding;
  });
})

document.querySelectorAll('.size').forEach(a => {
  const size = a.getAttribute('data-size');
  a.addEventListener('click', () => {
    quoteMask.style.height = size;
    quoteMask.style.width= size;
  });
})

document.querySelectorAll('.font').forEach(a => {
  const font = a.getAttribute('data-font');
  a.addEventListener('click', () => {
    quote.style.fontFamily = font;
  });
})

async function exportImage() {
  const canvas = await html2canvas(quote);
  const data = canvas.toDataURL();
  const link = document.createElement('a');
  link.href = data;
  link.download = 'quote.png';

  link.click();
}
