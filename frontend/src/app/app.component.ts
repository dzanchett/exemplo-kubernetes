import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UsersComponent } from './components/users/users.component';
import { ProductsComponent } from './components/products/products.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, UsersComponent, ProductsComponent],
  template: `
    <div class="container">
      <div class="header">
        <h1>?? Demo Kubernetes com Minikube</h1>
        <p>Microservi?os Laravel + Angular em Cluster Local</p>
      </div>

      <div class="tabs">
        <button 
          [class.active]="activeTab === 'users'"
          (click)="activeTab = 'users'">
          ?? Usu?rios
        </button>
        <button 
          [class.active]="activeTab === 'products'"
          (click)="activeTab = 'products'">
          ?? Produtos
        </button>
      </div>

      <div class="content-card">
        <app-users *ngIf="activeTab === 'users'"></app-users>
        <app-products *ngIf="activeTab === 'products'"></app-products>
      </div>

      <div class="footer">
        <p>?? Demonstra??o de Kubernetes Local com Minikube</p>
        <p>Backend: Laravel (PHP) | Frontend: Angular | Orquestra??o: Kubernetes</p>
      </div>
    </div>
  `,
  styles: []
})
export class AppComponent {
  activeTab: 'users' | 'products' = 'users';
}
