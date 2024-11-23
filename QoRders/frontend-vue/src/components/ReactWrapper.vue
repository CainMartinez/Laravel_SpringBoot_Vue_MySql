<template>
  <div ref="reactRoot"></div>
</template>

<script>
export default {
  name: 'ReactWrapper',
  mounted() {
    // Cargar el módulo UMD de React desde el servidor
    const script = document.createElement('script');
    script.src = 'http://localhost:8086/dist/DonationsPage.umd.js'; // Cambia la ruta si es diferente
    script.async = true;

    script.onload = () => {
      // Usar el componente exportado por UMD
      const ReactComponent = window.DonationsPage;
      ReactDOM.render(React.createElement(ReactComponent), this.$refs.reactRoot);
    };

    script.onerror = () => {
      console.error('Error al cargar el módulo React');
    };

    document.body.appendChild(script);
  },
  beforeUnmount() {
    // Limpia el componente React cuando se desmonta el wrapper
    ReactDOM.unmountComponentAtNode(this.$refs.reactRoot);
  },
};
</script>
