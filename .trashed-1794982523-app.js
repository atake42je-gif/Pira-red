import { View, Text, StyleSheet, ScrollView, TouchableOpacity } from 'react-native';

export default function App() {
  return (
    <View style={{flex:1, backgroundColor:'#eef2f7'}}>
      <ScrollView style={{paddingTop:50, padding:16}}>
        <View style={styles.header}>
          <Text style={{fontWeight:'900', color:'#0A66C2', fontSize:20}}>📍 PiraRed</Text>
          <Text style={{fontSize:12}}>Todo cerca. Todo conectado. Pirané</Text>
        </View>

        <Text style={styles.t}>Categorías</Text>
        <View style={styles.grid}>
          <View style={styles.card}><Text style={styles.icon}>🛒</Text><Text>Compra/Venta</Text></View>
          <View style={styles.card}><Text style={styles.icon}>🔧</Text><Text>Trabajos y Changas</Text></View>
          <View style={styles.card}><Text style={styles.icon}>⚙️</Text><Text>Servicios</Text></View>
          <View style={styles.card}><Text style={styles.icon}>📢</Text><Text>Publicidad</Text></View>
        </View>

        <Text style={styles.t}>Destacadas</Text>
        <View style={styles.item}><Text>🏍️ Yamaha YBR 125 2021 - $450.000 - Pirané</Text></View>
        <View style={styles.item}><Text>🚗 VW Gol Trend 2018 - $3.200.000 - Pirané</Text></View>
        <View style={styles.item}><Text>📱 iPhone 12 $950.000 - 128GB</Text></View>

        <TouchableOpacity style={styles.btn}><Text style={{color:'#fff', fontWeight:'900', textAlign:'center'}}>Publicar en PiraRed +</Text></TouchableOpacity>
      </ScrollView>
    </View>
  );
}
const styles = StyleSheet.create({
  header:{backgroundColor:'#fff', padding:16, borderRadius:18},
  t:{fontWeight:'900', marginTop:20, marginBottom:10, fontSize:16},
  grid:{flexDirection:'row', flexWrap:'wrap', justifyContent:'space-between'},
  card:{backgroundColor:'#fff', width:'48%', padding:18, borderRadius:16, alignItems:'center', marginBottom:10},
  icon:{fontSize:28},
  item:{backgroundColor:'#fff', padding:14, borderRadius:14, marginBottom:10},
  btn:{backgroundColor:'#0A66C2', padding:16, borderRadius:20, marginTop:16}
});
