import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService, Product } from '../../services/api.service';

@Component({
  selector: 'app-products',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div>
      <div class="service-info" *ngIf="serviceInfo">
        <div class="status">
          <span class="status-dot"></span>
          <span>{{ serviceInfo.service }} - {{ serviceInfo.status }}</span>
        </div>
        <span>v{{ serviceInfo.version }}</span>
      </div>

      <div class="loading" *ngIf="loading">
        ⏳ Carregando produtos...
      </div>

      <div class="error" *ngIf="error">
        ⚠️ {{ error }}
      </div>

      <div class="grid" *ngIf="!loading && !error && products.length > 0">
        <div class="card" *ngFor="let product of products">
          <h3>{{ product.name }}</h3>
          <p>🏷️ Categoria: {{ product.category }}</p>
          <p class="stock">📊 Estoque: {{ product.stock }} unidades</p>
          <p class="price">R$ {{ product.price.toFixed(2) }}</p>
          <span class="badge">ID: {{ product.id }}</span>
        </div>
      </div>

      <div *ngIf="!loading && !error && products.length === 0">
        <p style="text-align: center; color: #666;">Nenhum produto encontrado.</p>
      </div>
    </div>
  `,
  styles: []
})
export class ProductsComponent implements OnInit {
  products: Product[] = [];
  loading = true;
  error = '';
  serviceInfo: any = null;

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    this.loadServiceInfo();
    this.loadProducts();
  }

  loadServiceInfo(): void {
    this.apiService.getProductsHealth().subscribe({
      next: (data) => {
        this.serviceInfo = data;
      },
      error: (err) => {
        console.error('Erro ao carregar informações do serviço:', err);
      }
    });
  }

  loadProducts(): void {
    this.loading = true;
    this.error = '';

    this.apiService.getProducts().subscribe({
      next: (response) => {
        this.products = response.data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erro ao carregar produtos:', err);
        this.error = 'Não foi possível carregar os produtos. Verifique se o serviço está rodando.';
        this.loading = false;
      }
    });
  }
}
